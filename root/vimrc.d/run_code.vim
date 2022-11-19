autocmd FileType c :command! -nargs=0 RunCode :!cc % -o %:r && ./%:r
autocmd FileType cpp :command! -nargs=0 RunCode :!c++ % -o %:r && ./%:r
autocmd FileType python :command! -nargs=0 RunCode :!python3 %

nnoremap <Leader>rc :RunCode<CR>

