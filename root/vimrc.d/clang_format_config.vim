Plug 'rhysd/vim-clang-format'
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

autocmd FileType c,cpp,objc ClangFormatAutoEnable
let g:clang_format#style_options = { "BasedOnStyle": "Google" }
let g:clang_format#detect_style_fileheader = 1
