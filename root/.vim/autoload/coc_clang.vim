let g:clangd_path = get(g:, 'clangd_path', '/usr/bin/clangd-17')
let g:clangd_args = get(g:, 'clangd_args', [
      \               "--clang-tidy",
      \               "--compile-commands-dir=build",
      \               "--pretty",
      \               "--cross-file-rename",
      \               "--inlay-hints=true",
      \               "--background-index",
      \               "--suggest-missing-includes=true",
      \               "--header-insertion=iwyu",
      \       ])

let g:clang_format = get(g:, 'clang_format', 'clang-format')

function coc_clang#setup_coc_clangd()
  call coc#config('clangd.arguments', g:clangd_args)
  call coc#config('clangd.path', g:clangd_path)
endfunction

" alternative: https://github.com/rhysd/vim-clang-format
exe 'autocmd FileType c,cpp,cuda setlocal equalprg=' . g:clang_format . '\ -style=file'
