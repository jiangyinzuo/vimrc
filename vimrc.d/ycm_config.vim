let g:ycm_language_server =
            \[
            \   {
            \       'name': 'ccls',
            \       'cmdline': ['ccls'],
            \       'filetypes': ['c', 'cpp', 'objc', 'objcpp'],
            \       'project_root_files': ['.ccls-root', 'compile_commands.json']
            \   },
            \   {
            \       'name': 'rust',
            \       'cmdline': ['rust-analyzer'],
            \       'filetypes': ['rust'],
            \       'project_root_files': ['Cargo.toml'],
            \   },
            \]
let g:ycm_rust_toolchain_root = '/home/jiang/.rustup/toolchains/stable-x86_64-unknown-linux-gnu'
let g:ycm_error_symbol = 'K'
let g:ycm_warning_symbol = 'O'
let g:ycm_show_diagnostics_ui = 0  " 禁用YCM自带语法检查(使用ale)
let g:ycm_min_num_identifier_candidate_chars = 2
" 语法关键字补全
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_invoke_completion = '<c-Down>'

let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,java,lua,javascript': ['re!\w{2}'],
			\ }

" Do not show documentation when hovering the mouse, instead, use <leader>D
let g:ycm_auto_hover=''
nmap <leader>D <plug>(YCMHover)

let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
