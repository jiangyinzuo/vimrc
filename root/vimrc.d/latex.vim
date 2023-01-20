Plug 'lervag/vimtex'
let g:tex_flavor='latex'

" let g:vimtex_view_method='zathura'
" if has('win32') || (has('unix') && exists('$WSLENV'))
"   let g:vimtex_view_general_viewer = 'SumatraPDF.exe'
" 	let g:vimtex_view_general_options
" 	\ = '-reuse-instance  @tex @line @pdf'
" endif

let g:vimtex_quickfix_mode=1
set conceallevel=1
let g:tex_conceal='abdmg'
