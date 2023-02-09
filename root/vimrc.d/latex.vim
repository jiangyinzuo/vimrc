" usage: vim hello.tex world.tex --servername TEX
" inverse-search fearure requires +clientserver"
"
" sudo apt install texlive-latex-extra texlive-science latexmk xdotool
" :CocInstall coc-vimtex

Plug 'lervag/vimtex', {'for': 'tex'}
let g:tex_flavor='latex'

" alternative pdf viewer: 
" sudo apt install zathura evince mupdf
" let g:vimtex_view_method='zathura'

if (has('unix') && exists('$WSLENV'))
	let g:vimtex_view_general_viewer = $HOME.'/.vim/sumatrapdf.bash'
	let g:vimtex_view_general_options
				\ = "-reuse-instance -forward-search @tex @line @pdf -inverse-search \"wsl vim --servername TEX --remote-send \':SumatraPDF %l %f<CR>\'\""
	function SumatrapdfSendToVim(args)
		"24 d:\hello\world.tex -> ['24', 'd', '\hello\world.tex']
		let l:arglist = split(a:args, '[: ]') 
	
		let l:line = l:arglist[0]
		let l:diskname = l:arglist[1]
		let l:diskname = tolower(l:diskname)

		" \hello\world.tex -> /mnt/d/hello/world.tex
		let l:wslpath = l:arglist[2]
		let l:wslpath = substitute(l:wslpath, '\', "/", "g")
		
		let l:newargs = join([l:line, ' /mnt/', l:diskname, l:wslpath], '')
		execute 'edit +' . l:newargs
	endfunction

  command! -nargs=1 SumatraPDF call SumatrapdfSendToVim(<q-args>)
endif

let g:vimtex_quickfix_mode=1
set conceallevel=1
let g:tex_conceal='abdmg'

" use custom Makefile instead of latexmk
let g:vimtex_compiler_method = 'generic'
let g:vimtex_compiler_generic = {
			\ 'command': 'make',
			\}
