" Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#s_next = 1
" default s: delete [count] charaters and start insert
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T

if has('nvim') || v:version >= 801
	set nocursorline " vim-css-color插件下，set cursorline有性能问题
	" let g:AutoPairsMapBS = 1
	let g:AutoPairsMapSpace = 0
	
" Plug 'jiangyinzuo/vim-visual-multi', {'branch': 'master'}
	let g:VM_mouse_mappings             = 1
	let g:VM_theme                      = 'iceblue'
	let g:VM_highlight_matches          = 'underline'

	let g:VM_maps = {}
	let g:VM_maps['I CtrlF'] = ''
	let g:VM_maps['I Return'] = ''
	" Vim9 has a bug when maps to Esc
	" https://github.com/mg979/vim-visual-multi/issues/220
	let g:VM_maps['Exit'] = '<C-c>'
	let g:VM_maps['Add Cursor Down'] = '<C-j>'
	let g:VM_maps['Add Cursor Up'] = '<C-k>'
	let g:VM_maps['Add Cursor At Pos'] = '<C-h>'
	let g:VM_maps['Motion j'] = '<Down>'
	let g:VM_maps['Motion k'] = '<Up>'
	let g:VM_maps['Motion l'] = '<Right>'
	let g:VM_maps['Motion h'] = '<Left>'
endif

let test#strategy = "asyncrun_background_term"
let test#python#pytest#executable = 'python3 -m pytest'
let test#rust#cargotest#test_options = { 'nearest': ['--', '--nocapture', '--exact'], 'file': [] }

let g:mundo_help = 1
let g:mundo_preview_bottom = 1
let g:mundo_preview_height = 8
let g:mundo_right = 1

let g:templates_no_builtin_templates = 1
" autocmd may slow down vim startup time for deep directory
let g:templates_no_autocmd = 1
" Do not search too many parent directories, it is slow.
let g:templates_search_height = 1
	
let g:maximizer_set_default_mapping = 0
let g:maximizer_set_mapping_with_bang = 0
nnoremap <silent><C-w>m :MaximizerToggle<CR>
vnoremap <silent><C-w>m :MaximizerToggle<CR>gv
inoremap <silent><C-w>m <C-o>:MaximizerToggle<CR>

if has('nvim') || v:version >= 800
	let g:far#source = 'rg'
	let g:far#enable_undo = 1
	
	let g:qf_auto_open_quickfix = 0
	nmap <leader>cn <Plug>QfCnext
	nmap <leader>cp <Plug>QfCprevious
	nmap <leader>ln <Plug>QfLnext
	nmap <leader>lp <Plug>QfLprevious
	
	" 默认csv带有header
	let g:rbql_with_headers = 1
	let g:rainbow_comment_prefix = '#'
	" 禁用rainbow_csv的高亮
	" let g:rcsv_colorlinks = ['NONE', 'NONE']
	
	let g:open_gitdiff_exclude_patterns = ['\.pdf$', '\.jpg$', '\.png$', '\.eps$']
	let g:open_gitdiff_qf_nmaps = {'open': '<leader>df', 'next': '<leader>dn', 'prev': '<leader>dp'}
	let command_def = 'command -nargs=* '
	if v:version >= 901
			" open_gitdiff#comp#Complete is implemented with vim9class
			let command_def .= '-complete=custom,open_gitdiff#comp#Complete '
	endif
	exe command_def . 'GitDiffAll call open_gitdiff#OpenAllDiffs(<f-args>)'
	exe command_def . 'GitDiffThisTab call open_gitdiff#OpenDiff("tabnew", <f-args>)'
	exe command_def . 'GitDiffThis call open_gitdiff#OpenDiff("enew", <f-args>)'

	exe command_def . 'FZFGitDiffTab call open_gitdiff#select("tabnew", function("open_gitdiff#fzf#view"), <f-args>)'
	exe command_def . 'FZFGitDiff call open_gitdiff#select("enew", function("open_gitdiff#fzf#view"), <f-args>)'

	exe command_def . 'QuickUIGitDiffTab call open_gitdiff#select("tabnew", function("open_gitdiff#quickui#listbox#view"), <f-args>)'
	exe command_def . 'QuickUIGitDiff call open_gitdiff#select("enew", function("open_gitdiff#quickui#listbox#view"), <f-args>)'

	exe command_def . 'QfGitDiff call open_gitdiff#select("enew", function("open_gitdiff#quickfix#view"), <f-args>)'
	command -nargs=+ -complete=customlist,fugitive#LogComplete GitDiff2Paths call open_gitdiff#open_diff_by_path(<f-args>)
else
	nnoremap <silent> <leader>cn :cn<CR>
	nnoremap <silent> <leader>cp :cp<CR>
	nnoremap <silent> <leader>ln :ln<CR>
	nnoremap <silent> <leader>lp :lp<CR>
endif
noremap ]q :call noplug#ToggleQuickfix('c')<CR>
noremap ]l :call noplug#ToggleQuickfix('l')<CR>

let g:caser_prefix = 'gs'

let g:MergetoolSetLayoutCallback = function('mergetool_custom#MergetoolLayoutCallback')

" 即使pdf位于wsl中，typst也可以使用windows下的pdf阅读器
let g:typst_pdf_viewer = 'SumatraPDF.exe'

let g:gitgutter_sign_priority = 10
if !empty($USE_VIM_MERGETOOL)
	autocmd BufEnter * if get(g:, 'mergetool_in_merge_mode', 0) | :GitGutterBufferDisable | endif
endif

" 默认主题不显示colorcolumn
set colorcolumn=80,120
if !has('patch-9.1.176') || !has('nvim')
	" markdown会conceal一些字符，导致colorcolumn显示混乱
	autocmd FileType org,markdown,text setlocal colorcolumn=
endif
