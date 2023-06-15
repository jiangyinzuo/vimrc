" See also: root/vimrc.d/asynctasks.vim
function YankCodeLink()
	let t:coderepo_dir = asyncrun#get_root('%')
	let l:file = expand("%:p")[len(t:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:content = getline(".")
	" yank markdown snippet to register
	let @" = "+" . l:line . " " . l:file . "\n```" . &filetype . "\n" . l:content . "\n```\n"
	echom "t:coderepo_dir:" . t:coderepo_dir . "    yanked: " . l:file . " +" . l:line
endfunction

nnoremap <silent> cy :call YankCodeLink()<CR>

function s:edit_and_lcd(filename)
	execute "vsp"
	execute "edit " . a:filename
	execute "lcd " . expand("%:p:h")
endfunction

command -nargs=? -complete=dir OpenCodeRepoNote :let t:coderepo_dir = asyncrun#get_root('%') | call fzf#run(fzf#wrap({'source': 'fd -i', 'dir': <q-args>, 'sink': function("s:edit_and_lcd")}, <bang>0))<CR>

function GoToCodeLink()
	let l:dest = split(getline("."))
	let l:line = l:dest[0]
	let l:file = l:dest[1]
	exe "wincmd w"
	exe "edit " . l:line . " " . t:coderepo_dir . "/" . l:file
endfunction
nnoremap <silent> <leader>gf :call GoToCodeLink()<CR>
