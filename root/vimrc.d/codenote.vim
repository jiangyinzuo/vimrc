let g:codenote_window_mode = "tab" " split or tab

function s:set_coderepo_dir()
	let g:coderepo_dir = asyncrun#get_root('%')
	let w:repo_type = "code"
endfunction

function s:set_noterepo_dir()
	let g:noterepo_dir = asyncrun#get_root('%')
	let w:repo_type = "note"
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

function s:yank_to_register(line, file, content)
	" yank markdown snippet to register
	let @" = "+" . a:line . " " . a:file . "\n```" . &filetype . "\n" . a:content . "\n```\n"
endfunction

" See also: root/vimrc.d/asynctasks.vim
function YankCodeLink()
	call s:set_coderepo_dir()
	
	let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:content = getline(".")
	call s:yank_to_register(l:line, l:file, l:content)
endfunction

nnoremap <silent> cy :call YankCodeLink()<CR><C-W>w

function YankCodeLinkVisual()
	call s:set_coderepo_dir()
	
	let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
  let [l:line_start, l:column_start] = getpos("'<")[1:2]
	let l:content = GetVisualSelection()
	call s:yank_to_register(l:line_start, l:file, l:content)
endfunction
vnoremap <silent> cy :call YankCodeLinkVisual()<CR><C-W>w

function s:save_repo_dir()
	echom "s:save_repo_dir(): " . g:coderepo_dir . " " . g:noterepo_dir
	call system("echo " . g:coderepo_dir . " > " . g:noterepo_dir . "/.noterepo")
	call system("echo " . g:noterepo_dir . " > " . g:coderepo_dir . "/.coderepo")
endfunction

function s:open_file(filename)
	if g:codenote_window_mode == "tab"
		execute "tabnew " . a:filename
	else
		execute "vsp " . a:filename
	endif
endfunction

function s:goto_file()
	if g:codenote_window_mode == 'tab'
		tabn
	else
		wincmd w
	endif
endfunction

function s:open_note_repo(filename)
	call s:open_file(a:filename)
	call s:set_noterepo_dir()
	execute "lcd " . g:noterepo_dir
	
	call GetAllCodeLinks()
	call s:save_repo_dir()
endfunction

function OpenNoteRepo()
	call s:set_coderepo_dir()
	if !exists('g:noterepo_dir') || g:noterepo_dir == ""
		if $DOC2 == ''
			echom "$DOC2 is empty"
		endif
		call fzf#run(fzf#wrap({'source': 'fd -i -t f', 'dir': $DOC2, 'sink': function("s:open_note_repo")}))
	else
		call s:open_note_repo(g:noterepo_dir)
	endif
endfunction

command -nargs=0 OpenNoteRepo :silent! call OpenNoteRepo()<CR>

function s:open_code_repo(filename)
	call s:open_file(a:filename)
	call s:set_coderepo_dir()
	execute "lcd " . g:coderepo_dir

	call GetAllCodeLinks()
	call s:save_repo_dir()
endfunction

function OpenCodeRepo()
	call s:set_noterepo_dir()
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
	return g:codenote_window_mode == 'split' && winnr('$') == 1 || g:codenote_window_mode == 'tab' && tabpagenr('$') == 1
endfunction

function GoToCodeLink()
	let l:dest = split(getline("."))
	let l:line = l:dest[0]
	let l:file = l:dest[1]
	if s:only_has_one_repo()
		call OpenCodeRepo()
	else
		call s:goto_file()
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
		call s:goto_file()
	endif
	exe "vim /" . l:pattern . "/g" . asyncrun#get_root('%') . "/**" 
endfunction

function GoToCodeNoteLink()
	if w:repo_type == "note"
		call GoToCodeLink()
	elseif w:repo_type == "code"
		call GoToNoteLink()
	else
		echoerr "w:repo_type is not set"
	endif
endfunction

" 1) goto code/note link
" 2) put the cursor to center of screen
nnoremap <silent> <leader><C-]> :call GoToCodeNoteLink()<CR>z.

function LoadNote()
	let l:root = asyncrun#get_root('%')
	if !empty(glob(l:root . '/.noterepo'))
		let g:noterepo_dir = l:root
		" let g:coderepo_dir = trim(system("cat " . l:root . "/.noterepo"))
		let g:coderepo_dir = readfile(l:root . "/.noterepo", '', 1)[0]
		let w:repo_type = "note"
	endif
endfunction

function LoadCode()
	let l:root = asyncrun#get_root('%')
	if !empty(glob(l:root . '/.coderepo'))
		let g:coderepo_dir = l:root
		" let g:noterepo_dir = trim(system("cat " . l:root . "/.coderepo"))
		let g:noterepo_dir = readfile(l:root . "/.coderepo", '', 1)[0]
		let w:repo_type = "code"
	endif
endfunction

augroup codenote_load
	autocmd!
	autocmd BufWinEnter *.md call LoadNote()
	autocmd BufWinEnter * call LoadCode()
	autocmd BufEnter * call GetAllCodeLinks()
augroup END
