function coc_clang#setup_coc_clangd()
  call coc#config('clangd.arguments', g:clangd_args)
  call coc#config('clangd.path', g:clangd_path)
endfunction

" alternative: https://github.com/rhysd/vim-clang-format
exe 'autocmd FileType c,cpp,cuda setlocal equalprg=' . g:clang_format . '\ -style=file'
