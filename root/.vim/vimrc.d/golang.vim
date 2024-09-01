Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': ['go', 'gomod', 'gosum'] }
if v:version >= 801
  Plug 'sebdah/vim-delve', { 'for': 'go' }
endif
" 禁用vim-go的lsp功能，使用coc.nvim的lsp
let g:go_gopls_enabled = 0
let g:go_auto_type_info = 0
let g:go_code_completion_enabled = 0
let g:go_auto_sameids = 0
let g:go_fmt_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_diagnostics_enabled = 0
let g:go_echo_go_info = 0
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command = 'goimports'
let g:go_snippet_engine = "ultisnips" "optional neosnippet
let g:go_list_type = "quickfix"

let g:go_highlight_functions = 1
let g:go_highlight_function_closures = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_build_constraints = 1

" nmap <silent> gr :GoReferrers<CR>
"
let g:go_debug = []
let g:go_test_timeout = '10s'

" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_enabled = 0
let g:go_metalinter_deadline = "5s"
let g:go_metalinter_autosave = 0

