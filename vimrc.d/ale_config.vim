" Use ALE and coc.nvim together
let g:ale_disable_lsp = 1
let g:ale_lint_on_insert_leave = 1

let g:ale_completion_enabled = 1
"vim自带状态栏中整合ale
let g:ale_statusline_format = ['XXH  %d','W  %d','OK']
"显示linter名称,出错或警告等相关信息
let g:ale_sign_error = "E"
let g:ale_sign_warning = "W"

nnoremap <C-LeftMouse> :ALEGoToDefinition<CR>
let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }
" Required, explicitly enable Elixir LS
let g:ale_linters = {
\  'c': 'all',
\  'c++': 'all',
\  'rust': ['analyzer', 'rustfmt'],
\  'java': 'all',
\}

let g:ale_cpp_clangtidy_checks = []
let g:ale_cpp_clangtidy_executable = 'clang-tidy'
let g:ale_c_parse_compile_commands=1
let g:ale_cpp_clangtidy_extra_options = ''
let g:ale_cpp_clangtidy_options = ''
let g:ale_set_balloons=1
let g:ale_linters_explicit=1
let g:airline#extensions#ale#enabled=1

let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
