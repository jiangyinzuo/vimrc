function s:set_coderepo_dir(repo_dir)
	let g:coderepo_dir = a:repo_dir
	let t:repo_type = "code"
	execute "tcd " . g:coderepo_dir
endfunction

function s:set_noterepo_dir(repo_dir)
	let g:noterepo_dir = a:repo_dir
	let t:repo_type = "note"
	execute "tcd " . g:noterepo_dir
endfunction

sign define code_note_link text=🗅 texthl=Search

function SignCodeLinks()
	if !exists('g:code_link_dict') || !exists('g:coderepo_dir') || !exists('g:noterepo_dir')
		return
	endif
	if g:code_link_dict == {}
		return
	endif
	sign unplace * group=code_note_link
	let l:current_file = expand("%:p")
	if l:current_file[0:len(g:coderepo_dir) - 1] == g:coderepo_dir
		let l:current_file = l:current_file[len(g:coderepo_dir) + 1:]
		if has_key(g:code_link_dict, l:current_file)
			for l:line in g:code_link_dict[l:current_file]
				execute "sign place " . l:line . " line=" . l:line . " group=code_note_link" . " name=code_note_link file=" . l:current_file 
			endfor
		endif
	endif
endfunction

function GetCodeLinkDict()
	if !exists("g:noterepo_dir")
		echoerr "g:noterepo_dir is not set"
		return
	endif
	let g:code_links = system("rg -INo '^\\+[0-9]+ .*$' " . g:noterepo_dir)
	let g:code_links = split(g:code_links, "\n")

	let g:code_link_dict = {}
	for code_link in g:code_links
		let l:dest = split(code_link)
		let l:line = l:dest[0][1:]
		let l:file = l:dest[1]
		
		if has_key(g:code_link_dict, l:file)
			call add(g:code_link_dict[l:file], l:line)
		else
			let g:code_link_dict[l:file] = [l:line]
		endif
	endfor
endfunction

function GetAllCodeLinks()
	if exists('g:coderepo_dir') && g:coderepo_dir != "" && exists('g:noterepo_dir') && g:noterepo_dir != ""
		call GetCodeLinkDict()
		call SignCodeLinks()
		augroup codenote
			autocmd!
			autocmd BufWinEnter * call SignCodeLinks()
			autocmd BufWritePost *.md call GetCodeLinkDict()
		augroup END
	endif
endfunction

command -nargs=0 RefreshCodeLinks :call GetAllCodeLinks()

" 第一个tab作为note repo window，第二个tab作为code repo window
function s:goto_code_buffer()
	tabnext 2
endfunction

function s:goto_note_buffer()
	tabfirst
endfunction

function s:save_repo_dir()
	call assert_true(exists('g:coderepo_dir') && g:coderepo_dir != "")
	call assert_true(exists('g:noterepo_dir') && g:noterepo_dir != "")
	echom "s:save_repo_dir() g:coderepo_dir: " . g:coderepo_dir . " g:noterepo_dir: " . g:noterepo_dir
	call system("echo " . g:coderepo_dir . " > " . g:noterepo_dir . "/.noterepo")
	call system("echo " . g:noterepo_dir . " > " . g:coderepo_dir . "/.coderepo")
endfunction

function s:open_file(filename)
	execute "tabnew " . a:filename
endfunction

function s:open_note_repo(filename)
	call s:open_file(a:filename)
	tabmove 0
	call s:set_noterepo_dir(expand('%:p:h'))
	execute "tcd " . g:noterepo_dir
	
	call GetAllCodeLinks()
	call s:save_repo_dir()
endfunction

function OpenNoteRepo()
	if exists("t:repo_type") && t:repo_type == "note"
		echoerr "Already in note repo"
		return
	endif
	let l:root = asyncrun#get_root('%')
	call s:set_coderepo_dir(l:root)
	if !exists('g:noterepo_dir') || g:noterepo_dir == ""
		if $DOC2 == ''
			echom "$DOC2 is empty"
			return
		endif
		call fzf#run(fzf#wrap({'source': 'fd -i -t d', 'dir': $DOC2, 'sink': function("s:open_note_repo")}))
	else
		call s:open_note_repo(g:noterepo_dir)
	endif
endfunction

command -nargs=0 OpenNoteRepo :silent! call OpenNoteRepo()<CR>

function s:open_code_repo(filename)
	call s:open_file(a:filename)
	tabmove 1
	let l:root = asyncrun#get_root('%')
	call s:set_coderepo_dir(l:root)
	execute "tcd " . g:coderepo_dir

	call GetAllCodeLinks()
	call s:save_repo_dir()
endfunction

function OpenCodeRepo()
	if exists("t:repo_type") && t:repo_type == "code"
		echoerr "Already in code repo"
		return
	endif
	call s:set_noterepo_dir(expand('%:p:h'))
	if !exists('g:coderepo_dir') || g:coderepo_dir == ""
		call fzf#run(fzf#wrap({'source': 'fd -i -t f', 'dir': $CODE_HOME, 'sink': function("s:open_code_repo")}))
		if $CODE_HOME == ''
			echom "$DOC2 is empty"
		endif
	else
		call s:open_code_repo(g:coderepo_dir)
	endif
endfunction

command -nargs=0 OpenCodeRepo :silent! call OpenCodeRepo()<CR>

function s:only_has_one_repo()
	return tabpagenr('$') == 1
endfunction

function s:yank_registers(file, line, content, need_beginline, need_endline, append)
	if a:need_beginline && &filetype != 'markdown'
		let l:beginline = "```" . &filetype . "\n"
	else
		let l:beginline = ""
	endif
	if a:need_endline && &filetype != 'markdown'
		let l:endline = "```\n"
	else
		let l:endline = ""
	endif
	if a:append
		let @" .= "+" . a:line . " " . a:file . "\n" . l:beginline . a:content . "\n" . l:endline
		echo "append to @"
	else
		let @" = "+" . a:line . " " . a:file . "\n" . l:beginline . a:content . "\n" . l:endline
	endif
endfunction

" See also: root/vimrc.d/asynctasks.vim
function YankCodeLink(need_beginline, need_endline, append, goto_buf)
	if exists("t:repo_type") && t:repo_type == "code"
		if s:only_has_one_repo()
			call s:open_note_repo(g:noterepo_dir)
		endif
		let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
		let l:line = line(".")
		let l:content = getline(".")
		call s:yank_registers(l:file, l:line, l:content, a:need_beginline, a:need_endline, a:append)
		if a:goto_buf
			call s:goto_note_buffer()
		endif
	endif
endfunction

nnoremap <silent> cr :call YankCodeLink(0, 0, 0, 1)<CR>
nnoremap <silent> cy :call YankCodeLink(1, 1, 0, 1)<CR>
nnoremap <silent> cb :call YankCodeLink(1, 0, 0, 0)<CR>
nnoremap <silent> ca :call YankCodeLink(0, 0, 1, 0)<CR>
nnoremap <silent> ce :call YankCodeLink(0, 1, 1, 1)<CR>

function YankCodeLinkVisual(need_beginline, need_endline, append, goto_buf)
	if exists("t:repo_type") && t:repo_type == "code"
		if s:only_has_one_repo()
			call s:open_note_repo(g:noterepo_dir)
		endif
		let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
		let [l:line, l:column_start] = getpos("'<")[1:2]
		let l:content = GetVisualSelection()
		call s:yank_registers(l:file, l:line, l:content, a:need_beginline, a:need_endline, a:append)
		if a:goto_buf
			call s:goto_note_buffer()
		endif
	endif
endfunction

vnoremap <silent> cr :call YankCodeLinkVisual(0, 0, 0, 1)<CR>
vnoremap <silent> cy :call YankCodeLinkVisual(1, 1, 0, 1)<CR>
vnoremap <silent> cb :call YankCodeLinkVisual(1, 0, 0, 0)<CR>
vnoremap <silent> ca :call YankCodeLinkVisual(0, 0, 1, 0)<CR>
vnoremap <silent> ce :call YankCodeLinkVisual(0, 1, 1, 1)<CR>


function GoToCodeLink()
	let l:dest = split(getline("."))
	let l:line = l:dest[0]
	let l:file = l:dest[1]
	if s:only_has_one_repo()
		call OpenCodeRepo()
	else
		call s:goto_code_buffer()
	endif
	exe "edit " . l:line . " " . g:coderepo_dir . "/" . l:file
endfunction

function GoToNoteLink()
	let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:pattern = "+" . l:line . " " . l:file
	" 将 / 转义为 \/
	let l:pattern = substitute(l:pattern, "/", "\\\\/", "g")
	if s:only_has_one_repo()
		call OpenNoteRepo()
	else
		call s:goto_note_buffer()
	endif
	exe "vim /" . l:pattern . "/g" . asyncrun#get_root('%') . "/**/*.md" 
endfunction

function GoToCodeNoteLink()
	if t:repo_type == "note"
		call GoToCodeLink()
	elseif t:repo_type == "code"
		call GoToNoteLink()
	else
		echoerr "t:repo_type is not set"
	endif
endfunction

" 1) goto code/note link
" 2) put the cursor to center of screen
nnoremap <silent> <leader><C-]> :call GoToCodeNoteLink()<CR>z.

function LoadCodeNote()
	let l:root = asyncrun#get_root('%')
	if !empty(glob(l:root . '/.noterepo'))
		let g:noterepo_dir = l:root
		" let g:coderepo_dir = trim(system("cat " . l:root . "/.noterepo"))
		let g:coderepo_dir = readfile(l:root . "/.noterepo", '', 1)[0]
		let t:repo_type = "note"
		execute "tcd " . g:noterepo_dir
	elseif !empty(glob(l:root . '/.coderepo'))
		let g:coderepo_dir = l:root
		" let g:noterepo_dir = trim(system("cat " . l:root . "/.coderepo"))
		let g:noterepo_dir = readfile(l:root . "/.coderepo", '', 1)[0]
		let t:repo_type = "code"
		execute "tcd " . g:coderepo_dir
	endif
endfunction

command -nargs=0 Rglink :Rg ^\+[0-9]+ .+$
