function s:set_coderepo_dir()
	let t:coderepo_dir = asyncrun#get_root('%')
	let w:repo_type = "code"
endfunction

function s:set_noterepo_dir()
	let t:noterepo_dir = asyncrun#get_root('%')
	let w:repo_type = "note"
endfunction

sign define code_note_link text=🗅 texthl=Search

function SignCodeLinks()
	if !exists('t:code_link_dict') || !exists('t:coderepo_dir') || !exists('t:noterepo_dir')
		return
	endif
	if t:code_link_dict == {}
		return
	endif
	sign unplace * group=code_note_link
	let l:current_file = expand("%:p")
	if l:current_file[0:len(t:coderepo_dir) - 1] == t:coderepo_dir
		let l:current_file = l:current_file[len(t:coderepo_dir) + 1:]
		if has_key(t:code_link_dict, l:current_file)
			for l:line in t:code_link_dict[l:current_file]
				execute "sign place " . l:line . " line=" . l:line . " group=code_note_link" . " name=code_note_link file=" . l:current_file 
			endfor
		endif
	endif
endfunction

function GetCodeLinkDict()
	if !exists("t:noterepo_dir")
		echoerr "t:noterepo_dir is not set"
		return
	endif
	let t:code_links = system("rg -INo '^\\+[0-9]+ .*$' " . t:noterepo_dir)
	let t:code_links = split(t:code_links, "\n")

	let t:code_link_dict = {}
	for code_link in t:code_links
		let l:dest = split(code_link)
		let l:line = l:dest[0][1:]
		let l:file = l:dest[1]
		
		if has_key(t:code_link_dict, l:file)
			call add(t:code_link_dict[l:file], l:line)
		else
			let t:code_link_dict[l:file] = [l:line]
		endif
	endfor
endfunction

function GetAllCodeLinks()
	if exists('t:coderepo_dir') && t:coderepo_dir != "" && exists('t:noterepo_dir') && t:noterepo_dir != ""
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
	
	let l:file = expand("%:p")[len(t:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:content = getline(".")
	call s:yank_to_register(l:line, l:file, l:content)
endfunction

nnoremap <silent> cy :call YankCodeLink()<CR><C-W>w

function YankCodeLinkVisual()
	call s:set_coderepo_dir()
	
	let l:file = expand("%:p")[len(t:coderepo_dir) + 1:]
  let [l:line_start, l:column_start] = getpos("'<")[1:2]
	let l:content = GetVisualSelection()
	call s:yank_to_register(l:line_start, l:file, l:content)
endfunction
vnoremap <silent> cy :call YankCodeLinkVisual()<CR><C-W>w

function s:save_repo_dir()
	echom "s:save_repo_dir(): " . t:coderepo_dir . " " . t:noterepo_dir
	call system("echo " . t:coderepo_dir . " > " . t:noterepo_dir . "/.noterepo")
	call system("echo " . t:noterepo_dir . " > " . t:coderepo_dir . "/.coderepo")
endfunction

function s:open_note_repo(filename)
	execute "vsp " . a:filename
	call s:set_noterepo_dir()
	execute "lcd " . t:noterepo_dir
	
	call GetAllCodeLinks()
	call s:save_repo_dir()
endfunction

function OpenNoteRepo()
	call s:set_coderepo_dir()
	if !exists('t:noterepo_dir') || t:noterepo_dir == ""
		if $DOC2 == ''
			echom "$DOC2 is empty"
		endif
		call fzf#run(fzf#wrap({'source': 'fd -i -t f', 'dir': $DOC2, 'sink': function("s:open_note_repo")}))
	else
		call s:open_note_repo(t:noterepo_dir)
	endif
endfunction

command -nargs=0 OpenNoteRepo :silent! call OpenNoteRepo()<CR>

function s:open_code_repo(filename)
	execute "vsp " . a:filename
	call s:set_coderepo_dir()
	execute "lcd " . t:coderepo_dir

	call GetAllCodeLinks()
	call s:save_repo_dir()
endfunction

function OpenCodeRepo()
	call s:set_noterepo_dir()
	if !exists('t:coderepo_dir') || t:coderepo_dir == ""
		call fzf#run(fzf#wrap({'source': 'fd -i -t f', 'dir': $CODE_HOME, 'sink': function("s:open_code_repo")}))
		if $CODE_HOME == ''
			echom "$DOC2 is empty"
		endif
	else
		call s:open_code_repo(t:coderepo_dir)
	endif
endfunction

command -nargs=0 OpenCodeRepo :silent! call OpenCodeRepo()<CR>

function GoToCodeLink()
	let l:dest = split(getline("."))
	let l:line = l:dest[0]
	let l:file = l:dest[1]
	if winnr('$') == 1
		call OpenCodeRepo()
	else
		wincmd w
	endif
	exe "edit " . l:line . " " . t:coderepo_dir . "/" . l:file
endfunction

function GoToNoteLink()
	let l:file = expand("%:p")[len(t:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:pattern = "+" . l:line . " " . l:file
	" 将 / 转义为 \/
	let l:pattern = substitute(l:pattern, "/", "\\\\/", "g")
	if winnr('$') == 1
		call OpenNoteRepo()
	else
		wincmd w
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

nnoremap <silent> <leader><C-]> :call GoToCodeNoteLink()<CR>

function LoadNote()
	let l:root = asyncrun#get_root('%')
	if !empty(glob(l:root . '/.noterepo'))
		let t:noterepo_dir = l:root
		" let t:coderepo_dir = trim(system("cat " . l:root . "/.noterepo"))
		let t:coderepo_dir = readfile(l:root . "/.noterepo", '', 1)[0]
		let w:repo_type = "note"
	endif
endfunction

function LoadCode()
	let l:root = asyncrun#get_root('%')
	if !empty(glob(l:root . '/.coderepo'))
		let t:coderepo_dir = l:root
		" let t:noterepo_dir = trim(system("cat " . l:root . "/.coderepo"))
		let t:noterepo_dir = readfile(l:root . "/.coderepo", '', 1)[0]
		let w:repo_type = "code"
	endif
endfunction

augroup codenote_load
	autocmd!
	autocmd BufWinEnter *.md call LoadNote()
	autocmd BufWinEnter * call LoadCode()
	autocmd BufEnter * call GetAllCodeLinks()
augroup END
