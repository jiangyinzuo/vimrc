" Clangd
let g:nvim_lsp_autostart = {'clangd': v:true}
" use `CompilationDatabase` in .clangd instead
" let g:clangd_args = ["--clang-tidy", "--compile-commands-dir=build_debug", "--pretty", "--background-index", "--header-insertion=iwyu"]
" let g:clangd_cmd = [g:clangd_path] + g:clangd_args

" Ccls
" let g:nvim_lsp_autostart = {'ccls': v:true}
" let g:ccls_init_options = { "compilationDatabaseDirectory": "build_debug", "index": { "threads": 0 }, "clang": { "excludeArgs": ["-frounding-math"] }}

" Run google test using alepez/vim-gtest
function CustomGTestRun(cmd)
	" Use asyncrun.vim
	exe ":AsyncRun -pos=tab -mode=term -focus=1 " . a:cmd
endfunction

let g:gtest#gtest_runner = function('CustomGTestRun')
let g:gtest#gtest_command = "path/to/test/executable"
