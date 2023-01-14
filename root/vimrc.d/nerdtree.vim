Plug 'preservim/nerdtree'
""""""""""""""""""""""""""""""
"nerdtree settings
""""""""""""""""""""""""""""""
let NERDTreeShowHidden=1

nnoremap <leader>n :NERDTreeFocus<CR>
" https://zhuanlan.zhihu.com/p/458380268
" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Start NERDTree when Vim is started without file arguments.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
""""""""""""""""""""""""""""""
