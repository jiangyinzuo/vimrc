" clangd
let g:nvim_lsp_autostart = {'clangd': v:true}
let g:clangd_args = ["--clang-tidy", "--compile-commands-dir=build_debug", "--pretty", "--background-index", "--header-insertion=iwyu"]
let g:clangd_cmd = [g:clangd_path] + g:clangd_args

" ccls
" let g:nvim_lsp_autostart = {'ccls': v:true}
" let g:ccls_init_options = { "compilationDatabaseDirectory": "build_debug", "index": { "threads": 0 }, "clang": { "excludeArgs": ["-frounding-math"] }}
