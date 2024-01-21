"""""""""""""""""""""""""" Plugin Config """""""""""""""""""""""""""""

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

" Test framework
" Plug 'junegunn/vader.vim'

" Test wrapper
Plug 'vim-test/vim-test'
let test#strategy = "asyncrun_background_term"
let test#python#pytest#executable = 'python3 -m pytest'
let test#rust#cargotest#test_options = { 'nearest': ['--', '--nocapture', '--exact'], 'file': [] }

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
	Plug 'mbbill/undotree'
	Plug 'aperezdc/vim-template'
	let g:templates_no_builtin_templates = 1
	" set this configuration before loading the plugin
	let g:templates_no_autocmd = 0
	
	Plug 'szw/vim-maximizer'
	let g:maximizer_set_default_mapping = 0
	let g:maximizer_set_mapping_with_bang = 0
	nnoremap <silent><C-w>m :MaximizerToggle<CR>
	vnoremap <silent><C-w>m :MaximizerToggle<CR>gv
	inoremap <silent><C-w>m <C-o>:MaximizerToggle<CR>

	Plug 'preservim/vimux'
	
	" Remove ~/.vim/autoload/detect_indent.vim
	" Since: v0.12.0
	if v:version >= 901
	  packadd! editorconfig
	else
	  Plug 'editorconfig/editorconfig-vim'
	endif
	let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
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
		Plug 'SirVer/ultisnips'
		" 大多数情况下使用coc-ultisnips的回车键补全，若遇到tb23
		" 这样的补全，使用F12
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

	Plug 'godlygeek/tabular'
	Plug 'axvr/org.vim'
	Plug 'rust-lang/rust.vim'
	Plug 'kaarmu/typst.vim'
	" 即使pdf位于wsl中，typst也可以使用windows下的pdf阅读器
	let g:typst_pdf_viewer = 'SumatraPDF.exe'

	if has('nvim') && !g:nvim_compatibility_with_vim
		" Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

		Plug 'nvim-lualine/lualine.nvim'
		" If you want to have icons in your statusline choose one of these
		Plug 'kyazdani42/nvim-web-devicons'
		Plug 'linrongbin16/lsp-progress.nvim'

		Plug 'williamboman/mason.nvim'
		Plug 'neovim/nvim-lspconfig'
		" JSON schema
		" Plug 'b0o/schemastore.nvim'  
		" Plug 'jose-elias-alvarez/null-ls.nvim'
		Plug 'simrat39/rust-tools.nvim'
		Plug 'p00f/clangd_extensions.nvim'
		Plug 'simrat39/symbols-outline.nvim'
		Plug 'mfussenegger/nvim-dap'
		Plug 'rcarriga/nvim-dap-ui'
		Plug 'theHamsta/nvim-dap-virtual-text'
		Plug 'folke/neodev.nvim'

		Plug 'SmiteshP/nvim-navic'

		Plug 'nvim-lua/plenary.nvim'
		Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
		Plug 'nvim-telescope/telescope-file-browser.nvim'

		" completion(use ultisnips)
		Plug 'hrsh7th/cmp-nvim-lsp'
		Plug 'hrsh7th/cmp-buffer'
		Plug 'hrsh7th/cmp-path'
		Plug 'hrsh7th/cmp-cmdline'
		Plug 'hrsh7th/nvim-cmp'

		Plug 'quangnguyen30192/cmp-nvim-ultisnips'
	else
		Plug 'nordtheme/vim', { 'as': 'nordtheme' }
		Plug 'dracula/vim', { 'as': 'dracula' }
		Plug 'tomasiser/vim-code-dark'
		" Plug 'morhetz/gruvbox'

		if v:version >= 900
			" Alternative: https://github.com/gelguy/wilder.nvim
			Plug 'girishji/autosuggest.vim'
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

	" Plug 'MattesGroeger/vim-bookmarks'
	if has('nvim') || v:version >= 802
		Plug 'pechorin/any-jump.vim'
		Plug 'ojroques/vim-oscyank', {'branch': 'main'}
		" vnoremap <leader>c :OSCYank<CR>
	
		" require +job
		Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
		let g:pydocstring_doq_path = 'doq'
		let g:pydocstring_formatter = 'numpy'
	endif
	if has('terminal')
		source ~/.vim/vimrc.d/floaterm.vim
	endif
	source ~/.vim/vimrc.d/ai.vim
	source ~/.vim/vimrc.d/cpp.vim
	source ~/.vim/vimrc.d/golang.vim
	source ~/.vim/vimrc.d/java.vim

	Plug 'jiangyinzuo/vim-gtest'
	Plug 'lambdalisue/doctest.vim'
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

	source ~/.vim/vimrc.d/markdown.vim
	if has('nvim') || v:version >= 802
		source ~/.vim/vimrc.d/fzf.vim
		source ~/.vim/vimrc.d/jupyter.vim
	endif
	Plug 'whonore/Coqtail'
	source ~/.vim/vimrc.d/latex.vim
	source ~/.vim/vimrc.d/asynctasks.vim

	" codenote.vim depends on fzf.vim
	source ~/.vim/vimrc.d/codenote.vim

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

endif

" Initialize plugin system
call plug#end()

if glob(g:vim_plug_dir) == ""
	let g:no_plug = 1
	finish
endif

" 默认主题不显示colorcolumn
set colorcolumn=80,120
" markdown会conceal一些字符，导致colorcolumn显示混乱
autocmd FileType org,markdown,text setlocal colorcolumn=

if v:version >= 802
	if g:vimrc_use_coc
		source ~/.vim/vimrc.d/coc.vim
	endif
endif

"""""""""""""""""" begin colorscheme
if has("termguicolors") && ($COLORTERM == 'truecolor' || g:vimrc_use_true_color)
	set termguicolors
endif

let g:nord_uniform_diff_background = 1
let g:dracula_high_contrast_diff = 1

if g:vimrc_dark == 1
	set background=dark
else
	set background=light
endif
if v:version >= 800 || has('nvim')
	" true color support
	" https://github.com/lifepillar/vim-solarized8#troubleshooting
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	let g:solarized_diffmode = "normal"
	colorscheme solarized8
else
	if $COLORTERM != "truecolor"
		let g:solarized_termcolors = 256
	endif
	colorscheme solarized
	hi SignColumn ctermfg=None ctermbg=None guifg=None guibg=None
endif
" tab颜色
hi clear SpecialKey
hi NonText cterm=None term=None gui=None
hi link SpecialKey NonText
"hi SpecialKey ctermfg=darkgray guifg=#5a5a5a
"""""""""""""""""" end colorscheme

if has('nvim') || v:version >= 801
	let g:AutoPairs = autopairs#AutoPairsDefine([
				\ {"open": "<", "close": ">", "filetype": ["html"]}
				\ ]) " This is a filetype-specific mapping
	let g:AutoPairsLanguagePairs['vifm'] = g:AutoPairsLanguagePairs['vim']
endif

if has('nvim') || v:version >= 802
	hi CocCursorRange cterm=reverse guibg=#ebdbb2 guifg=#b16286
	source ~/.vim/vimrc.d/project.vim
endif
hi debugPC term=reverse ctermbg=4 guibg=DarkBlue
hi debugBreakpoint term=reverse ctermbg=red guibg=red
