" usage: vim hello.tex world.tex --servername TEX
" Requirement: inverse-search fearure requires +clientserver"
"
" sudo apt install texlive-latex-extra texlive-science latexmk xdotool texlive-publishers
" :CocInstall coc-vimtex coc-texlab

let g:tex_flavor = 'latex'
let g:tex_conceal = 'admgs'

" alternative pdf viewer: 
" sudo apt install zathura evince mupdf

if exists('$WSLENV') && (has('clientserver') || has('nvim'))
	let g:vimtex_view_general_viewer = $VIMRC_ROOT.'/scripts/sumatrapdf.zsh'

	if !has('nvim')
		" 需要提前编译no_terminal.exe
		" ISSUE: 反向搜索在多latex文件时可能不精准
		let g:vimtex_view_general_options
					\ = "-reuse-instance -forward-search @tex @line @pdf -inverse-search \"D:/no_terminal.exe  \\\"wsl vim --servername TEX --remote-send \':SumatraPDF %l %f<CR>\'\\\"\""
		command! -nargs=1 SumatraPDF call latex#SumatraPDFSendToVim(<q-args>)
	endif
endif

" The quickfix window is never opened/closed automatically.
let g:vimtex_quickfix_mode = 0
let g:vimtex_view_automatic = 0
let g:vimtex_toc_todo_labels = { 'TODO': 'TODO: ', 'FIXME': 'FIXME: ', 'ISSUE': 'ISSUE: ', 'NOTE': 'NOTE: '}
" vimtex fold is too slow!!!
let g:vimtex_fold_enabled = 0

let g:vimtex_compiler_method = 'latexmk'
" use custom Makefile instead of latexmk by default
" let g:vimtex_compiler_method = 'generic'
" let g:vimtex_compiler_generic = {
" 			\ 'command': 'make',
" 			\}

let g:vimtex_syntax_conceal = {
			\ 'accents': 1,
			\ 'ligatures': 1,
			\ 'cites': 1,
			\ 'fancy': 1,
			\ 'spacing': 0,
			\ 'greek': 1,
			\ 'math_bounds': 1,
			\ 'math_delimiters': 1,
			\ 'math_fracs': 1,
			\ 'math_super_sub': 1,
			\ 'math_symbols': 1,
			\ 'sections': 0,
			\ 'styles': 0,
			\}

" Plug 'PatrBal/vim-textidote'
