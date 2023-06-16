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
			add(t:code_link_dict[l:file], l:line)
		else
			let t:code_link_dict[l:file] = [l:line]
		endif
	endfor
endfunction

function GetAllCodeLinks()
	call GetCodeLinkDict()
	call SignCodeLinks()
	augroup codenote
		autocmd!
		autocmd BufEnter * call SignCodeLinks()
		autocmd BufWritePost *.md call GetCodeLinkDict()
	augroup END
endfunction

command -nargs=0 RefreshCodeLinks :call GetAllCodeLinks()

" See also: root/vimrc.d/asynctasks.vim
function YankCodeLink()
	call s:set_coderepo_dir()
	
	let l:file = expand("%:p")[len(t:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:content = getline(".")
	" yank markdown snippet to register
	let @" = "+" . l:line . " " . l:file . "\n```" . &filetype . "\n" . l:content . "\n```\n"
	echom "t:coderepo_dir:" . t:coderepo_dir . "    yanked: " . l:file . " +" . l:line
	wincmd w
endfunction

nnoremap <silent> cy :call YankCodeLink()<CR>

function s:edit_and_lcd(filename)
	execute "vsp " . a:filename
	execute "lcd " . expand("%:h")
	
	call s:set_noterepo_dir()
	call GetAllCodeLinks()
endfunction

command -nargs=1 -complete=dir OpenNoteRepo :call s:set_coderepo_dir() | call fzf#run(fzf#wrap({'source': 'fd -i', 'dir': <q-args>, 'sink': function("s:edit_and_lcd")}, <bang>0))<CR>

function s:lcd_and_set_root(filename)
	execute "vsp " . a:filename
	execute "lcd " . expand("%:h")
	let t:coderepo_dir = asyncrun#get_root('%')
	let w:repo_type = "code"
	call GetAllCodeLinks()
endfunction

command -nargs=1 -complete=dir OpenCodeRepo :call s:set_noterepo_dir() | call fzf#run(fzf#wrap({'source': 'fd -i', 'dir': <q-args>, 'sink': function("s:lcd_and_set_root")}, <bang>0))<CR>

function GoToCodeLink()
	let l:dest = split(getline("."))
	let l:line = l:dest[0]
	let l:file = l:dest[1]
	wincmd w
	exe "edit " . l:line . " " . t:coderepo_dir . "/" . l:file
endfunction

function GoToNoteLink()
	let l:file = expand("%:p")[len(t:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:pattern = "+" . l:line . " " . l:file
	" 将 / 转义为 \/
	let l:pattern = substitute(l:pattern, "/", "\\\\/", "g")
	wincmd w
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

