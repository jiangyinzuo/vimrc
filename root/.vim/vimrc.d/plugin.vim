function Cond(cond, ...)
	let opts = get(a:000, 0, {})
	return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" run
" :source %
" to update
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(g:vim_plug_dir)

" similar Plugin: Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
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
	Plug 'ap/vim-css-color'
	Plug 'LunarWatcher/auto-pairs'
	" let g:AutoPairsMapBS = 1
	let g:AutoPairsMapSpace = 0
	Plug 'markonm/traces.vim'

	" fix conflict with autopairs
	Plug 'jiangyinzuo/vim-visual-multi', {'branch': 'master'}
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

if !exists('g:vscode')
	" Test framework
	" Plug 'junegunn/vader.vim'

	" Test wrapper
	Plug 'vim-test/vim-test'
	let test#strategy = "asyncrun_background_term"
	let test#python#pytest#executable = 'python3 -m pytest'
	let test#rust#cargotest#test_options = { 'nearest': ['--', '--nocapture', '--exact'], 'file': [] }

	Plug 'mbbill/undotree'
	Plug 'aperezdc/vim-template'
	let g:templates_no_builtin_templates = 1
	" autocmd may slow down vim startup time for deep directory
	let g:templates_no_autocmd = 1
	" Do not search too many parent directories, it is slow.
	let g:templates_search_height = 1
	
	Plug 'szw/vim-maximizer'
	let g:maximizer_set_default_mapping = 0
	let g:maximizer_set_mapping_with_bang = 0
	nnoremap <silent><C-w>m :MaximizerToggle<CR>
	vnoremap <silent><C-w>m :MaximizerToggle<CR>gv
	inoremap <silent><C-w>m <C-o>:MaximizerToggle<CR>

	" Remove ~/.vim/autoload/detect_indent.vim
	" Since: v0.12.0
	if v:version >= 901
		packadd! editorconfig
	else
		Plug 'editorconfig/editorconfig-vim'
	endif
	let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'gitdiff://.*', 'scp://.*']
	au FileType gitcommit let b:EditorConfig_disable = 1
	" vim-sleuth does not behave as expected.
	" Plug 'tpope/vim-sleuth'

	" Commenting blocks of code.
	" 可以选中多行后，用:norm i# 在所有行前面添加#
	" :norm 0i 在所有行前面添加
	" :norm ^i 在所有行前面添加(不包括空格)
	" :norm 0x删除所有行的第一个字母
	" :norm ^x删除所有行的第一个字母(不包括空格)
	"
	" Replace custom commands for commenting.
	" Since: v0.12.0
	" See Also: https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim
	Plug 'tpope/vim-commentary'

	" enhanced ga(show not only ascii code, but also unicode code, emoji,
	" digraphs, etc.)
	" See Also: :h :ascii
	Plug 'tpope/vim-characterize'

	if has('nvim') || v:version >= 800
		Plug 'preservim/vimux'
		Plug 'SirVer/ultisnips'
		" 大多数情况下使用coc-ultisnips的回车键补全，若遇到tb23
		" 这样的补全，使用F12
		" nmap中F12被映射为打开终端, see floaterm.vim
		let g:UltiSnipsExpandTrigger="<f12>"

		" modify some snippets
		Plug 'jiangyinzuo/vim-snippets', { 'branch': 'mysnippets' }
		Plug 'lifepillar/vim-solarized8'
		Plug 'voldikss/vim-translator'
		Plug 'romainl/vim-qf'
		let g:qf_auto_open_quickfix = 0

		Plug 'mechatroner/rainbow_csv', { 'for': 'csv' }
		" 默认csv带有header
		let g:rbql_with_headers = 1
		let g:rainbow_comment_prefix = '#'
		" 禁用rainbow_csv的高亮
		" let g:rcsv_colorlinks = ['NONE', 'NONE']
	endif

	" vim-surround和vim-sneak会共享s/S shortcut，但不冲突
	" 创建surround类文本对象
	Plug 'tpope/vim-surround'
	" Vim sugar for the UNIX shell commands that need it the most
	Plug 'tpope/vim-eunuch'
	" 针对某些编程语言，快速分开/合并语句, 改进原生的gJ
	Plug 'AndrewRadev/splitjoin.vim'
	" 改进查找替换
	Plug 'tpope/vim-abolish'
	Plug 'arthurxavierx/vim-caser'
	let g:caser_prefix = 'gs'

	Plug 'preservim/tagbar'
	" See: https://github.com/liuchengxu/vista.vim/issues/462
	Plug 'liuchengxu/vista.vim'
	Plug 'samoshkin/vim-mergetool'

	let g:MergetoolSetLayoutCallback = function('mergetool_custom#MergetoolLayoutCallback')

	Plug 'godlygeek/tabular'
	Plug 'axvr/org.vim', { 'for': 'org' }
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }
	Plug 'kaarmu/typst.vim', { 'for': 'typst' }
	" 即使pdf位于wsl中，typst也可以使用windows下的pdf阅读器
	let g:typst_pdf_viewer = 'SumatraPDF.exe'

	if has('nvim') && !g:nvim_compatibility_with_vim
		source ~/.vim/vimrc.d/plugin_nvim.vim
	else
		" Plug 'nordtheme/vim', { 'as': 'nordtheme' }
		" Plug 'dracula/vim', { 'as': 'dracula' }
		" Plug 'tomasiser/vim-code-dark'
		" Plug 'morhetz/gruvbox'

		if v:version >= 900
			" Alternative: https://github.com/gelguy/wilder.nvim
			Plug 'girishji/autosuggest.vim'
			" External cmd is slow.
			autocmd VimEnter * ++once if exists('g:AutoSuggestSetup') | call g:AutoSuggestSetup({ 'cmd': { 'exclude': ['!'] }}) | endif
		endif
		if v:version >= 802
			if g:vimrc_use_coc
				" Use release branch (recommend)
				Plug 'neoclide/coc.nvim', {'branch': 'release'}
				Plug 'antoinemadec/coc-fzf'
				" fix bug 'Auto jump to the first line after exit from the floating
				" window of CocFzfLocation'
				" https://github.com/antoinemadec/coc-fzf/issues/113
				let g:coc_fzf_location_delay = 20
			endif
			if g:vimrc_use_vimspector
				Plug 'puremourning/vimspector'
				let g:vimspector_enable_mappings='VISUAL_STUDIO'

				" See: https://puremourning.github.io/vimspector/configuration.html#configuration-format
				" There are two locations for debug configurations for a project:
				" 
				" g:vimspector_configurations vim variable (dict)
				" <vimspector home>/configurations/<OS>/<filetype>/*.json
				" .vimspector.json in the project source
				"
				" json配置位于.vim/configurationsw目录下
				let g:vimspector_base_dir = $HOME . '/.vim'
				let g:vimspector_sign_priority = {
							\    'vimspectorBP':          20,
							\    'vimspectorBPCond':      20,
							\    'vimspectorBPLog':       20,
							\    'vimspectorBPDisabled':  20,
							\    'vimspectorNonActivePC': 20,
							\    'vimspectorPC':          999,
							\    'vimspectorPCBP':        999,
							\ }
			endif
			Plug 'jiangyinzuo/term-debugger'
		endif
		if v:version >= 800
			source ~/.vim/vimrc.d/leaderf.vim
		endif
	endif

	Plug 'airblade/vim-gitgutter'
	let g:gitgutter_sign_priority = 10
	if !empty($USE_VIM_MERGETOOL)
		autocmd BufEnter * if get(g:, 'mergetool_in_merge_mode', 0) | :GitGutterBufferDisable | endif
	endif
	" FZF :Commits依赖vim-fugitive
	Plug 'tpope/vim-fugitive'
	" A git commit browser.
	Plug 'junegunn/gv.vim'
	if has('vim9script')
		Plug 'Clavelito/indent-awk.vim'
		Plug 'Eliot00/git-lens.vim'
		let g:GIT_LENS_ENABLED = 0
	endif

	Plug 'jiangyinzuo/open-gitdiff.vim'
	let g:open_gitdiff_exclude_patterns = ['\.pdf$', '\.jpg$', '\.png$']
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

	" Plug 'MattesGroeger/vim-bookmarks'
	source ~/.vim/vimrc.d/ai.vim
	Plug 'bfrg/vim-cpp-modern', {'for': ['c', 'cpp', 'cuda']}
	" Enable function highlighting (affects both C and C++ files)
	let g:cpp_function_highlight = 1
	" Enable highlighting of C++11 attributes
	let g:cpp_attributes_highlight = 1
	" Highlight struct/class member variables (affects both C and C++ files)
	let g:cpp_member_highlight = 1
	" Put all standard C and C++ keywords under Vim's highlight group 'Statement' (affects both C and C++ files)
	let g:cpp_simple_highlight = 1
	source ~/.vim/vimrc.d/golang.vim

	Plug 'alepez/vim-gtest', {'for': ['c', 'cpp', 'cuda']}
	Plug 'lambdalisue/doctest.vim', {'for': 'python'}
	augroup doctest
		autocmd! *
			autocmd QuickFixCmdPost lDoctest nested lwindow
	augroup END

	" paste img in markdown/latex style
	Plug 'jiangyinzuo/img-paste.vim'
	let g:mdip_imgdir = '.'
	let g:mdip_wsl_path = '\\\\wsl.localhost\\Ubuntu-22.04'
	function! g:LatexPasteImage(relpath)
		execute "normal! i\\includegraphics{" . a:relpath . "}\r\\caption{I"
		let ipos = getcurpos()
		execute "normal! a" . "mage}"
		call setpos('.', ipos)
		execute "normal! ve\<C-g>"
	endfunction
	" autocmd FileType markdown let g:PasteImageFunction = 'g:MarkdownPasteImage'
	autocmd FileType tex let g:PasteImageFunction = 'g:LatexPasteImage'
	autocmd FileType markdown,tex nmap <buffer><silent> <leader>pi :call mdip#MarkdownClipboardImage()<CR>

	if has('nvim') || v:version >= 802
		Plug 'skywind3000/vim-quickui'
		let g:quickui_color_scheme = 'system'
		let g:quickui_context = [['hello', 'echo "hello world!"']]
		let g:quickui_border_style = 2
		Plug 'pechorin/any-jump.vim'
		" Alternative? https://github.com/jasonccox/vim-wayland-clipboard
		" See:
		" https://github.com/vim/vim/pull/9639
		" https://github.com/vim/vim/releases/tag/v9.1.0064
		Plug 'ojroques/vim-oscyank', {'branch': 'main'}
		" vnoremap <leader>c :OSCYank<CR>
	
		source ~/.vim/vimrc.d/floaterm.vim
		source ~/.vim/vimrc.d/fzf.vim

		" require +job
		Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
		let g:pydocstring_doq_path = 'doq'
		let g:pydocstring_formatter = 'numpy'

		" vim和jupyter notebook同步
		Plug 'imbue-ai/jupyter_ascending.vim', {'for': 'python'}
		let g:jupyter_ascending_default_mappings = 0
		let g:jupyter_ascending_python_executable = 'python3'
		" 同步到浏览器内存中，若要同步到.ipynb文件中，需要浏览器手动/自动定时保存
		" 或执行 jupytext --to ipynb hello2.sync.py，(虽然会丢失执行结果)
		let g:jupyter_ascending_auto_write = v:true
		
		" vim和jupyter console/qtconsole同步
		Plug 'jupyter-vim/jupyter-vim', {'for': 'python'}

		" ipynb打开时显示python
		Plug 'goerz/jupytext.vim'
		let g:jupytext_fmt = 'py'

		Plug 'jpalardy/vim-slime', {'for': ['python', 'ocaml']}
		" ocaml utop在第一次send时可能会失败，需要再send一次，或提前打开:SlimeConfig
		let g:slime_target = "vimterminal"
		let g:slime_no_mappings = 1
		xmap <leader>sp <Plug>SlimeRegionSend
		nmap <leader>sl <Plug>SlimeLineSend
		nmap <leader>sp <Plug>SlimeParagraphSend
		nmap <leader>sc <Plug>SlimeSendCell

		source ~/.vim/vimrc.d/markdown.vim
		source ~/.vim/vimrc.d/latex.vim
		source ~/.vim/vimrc.d/asynctasks.vim
	endif
	Plug 'whonore/Coqtail', { 'for': 'coq' }

	"""""""" Yank """"""""""
	" 复制pathline用于gF文件跳转
	" See rffv() in fzf/fzf.bash
	" [[palette]]复制当前文件:行的pathline				:YankPathLine
	command! -nargs=0 YankPathLine call yank#YankPathLine()
	" [[palette]]复制当前文件:行的pathline+content			:YankPathLineAndContent
	command! -nargs=0 -range YankPathLineAndContent '<,'>call yank#YankPathLineAndContent()
	command! -range -nargs=0 YankGDB <line1>,<line2>call yank#YankGDB()
	""""""""""""""""""""""""

	" if exists("$WSLENV")
	" 	" https://github.com/alacritty/alacritty/issues/2324#issuecomment-1339594232
	" 	inoremap <C-v> <ESC>:silent r!pbpaste<CR>'.kJ
	" endif

	""" DuckDB
	let g:duckdb_exe = 'duckdb -markdown'
	" [[palette]]DuckDB执行SQL,输出到terminal				:DuckDBExec select 42
	command -nargs=1 DuckDBExec call duckdb#DuckDBExec(<q-args>)
	" [[palette]]DuckDB执行文件里的SQL,输出到terminal			:DuckDBExec foo.sql
	command -nargs=1 -complete=file DuckDBExecFile call duckdb#DuckDBExec('.read ' . <q-args>)
	"""
endif " !exists('g:vscode')

" Initialize plugin system
call plug#end()

if g:no_plug
	finish
endif

"""""""""""""""""" begin colorscheme
if has("termguicolors") && ($COLORTERM == 'truecolor' || g:vimrc_use_true_color)
	set termguicolors
endif

let g:nord_uniform_diff_background = 1
let g:dracula_high_contrast_diff = 1

if (v:version >= 800 || has('nvim'))
	" true color support
	" https://github.com/lifepillar/vim-solarized8#troubleshooting
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	let g:solarized_diffmode = "normal"
	colorscheme solarized8
	hi NonText cterm=None term=None gui=None
endif
" tab颜色
hi clear SpecialKey
hi link SpecialKey NonText
"hi SpecialKey ctermfg=darkgray guifg=#5a5a5a
hi debugPC term=reverse ctermbg=4 guibg=DarkBlue
hi debugBreakpoint term=reverse ctermbg=red guibg=red
"""""""""""""""""" end colorscheme

" 默认主题不显示colorcolumn
set colorcolumn=80,120
" markdown会conceal一些字符，导致colorcolumn显示混乱
autocmd FileType org,markdown,text setlocal colorcolumn=

if (v:version >= 802 || has('nvim') && g:nvim_compatibility_with_vim) && g:vimrc_use_coc
	source ~/.vim/vimrc.d/coc.vim
endif

if has('nvim') || v:version >= 801
	let g:AutoPairs = autopairs#AutoPairsDefine([
				\ {"open": "<", "close": ">", "filetype": ["html"]}
				\ ]) " This is a filetype-specific mapping
	let g:AutoPairsLanguagePairs['vifm'] = g:AutoPairsLanguagePairs['vim']
endif

if v:version >= 900
	" any-jump.vim and autosuggest.vim conflict with search.vim
	" https://github.com/pechorin/any-jump.vim/issues/106
	runtime! autoload/search.vim
endif
