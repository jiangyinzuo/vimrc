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
	Plug 'LunarWatcher/auto-pairs'
	" let g:AutoPairsMapBS = 1
	Plug 'markonm/traces.vim'
endif

" do not use coc.nvim: https://github.com/neoclide/coc.nvim/wiki/Multiple-cursors-support
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
let g:VM_mouse_mappings             = 1
let g:VM_theme                      = 'iceblue'
let g:VM_highlight_matches          = 'underline'

let g:VM_maps = {}
let g:VM_maps["Undo"]      = 'u'
let g:VM_maps["Redo"]      = 'U'
" Vim9 has a bug when maps to Esc
" https://github.com/mg979/vim-visual-multi/issues/220
let g:VM_maps["Exit"] = '<C-c>'

Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
au FileType gitcommit let b:EditorConfig_disable = 1

if !exists('g:vscode')

	if has('nvim') || v:version >= 800
		Plug 'SirVer/ultisnips'
		Plug 'jiangyinzuo/vim-snippets', { 'branch': 'mysnippets' }
		Plug 'lifepillar/vim-solarized8'
		Plug 'voldikss/vim-translator'
		Plug 'romainl/vim-qf'
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

	Plug 'preservim/tagbar'
	" See: https://github.com/liuchengxu/vista.vim/issues/462
	Plug 'liuchengxu/vista.vim'
	" Plug 'samoshkin/vim-mergetool'

	Plug 'axvr/org.vim'
	Plug 'rust-lang/rust.vim'
	
	if has('nvim') && !g:nvim_compatibility_with_vim
		Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

		Plug 'nvim-lualine/lualine.nvim'
		" If you want to have icons in your statusline choose one of these
		Plug 'kyazdani42/nvim-web-devicons'
		Plug 'linrongbin16/lsp-progress.nvim'

		Plug 'williamboman/mason.nvim'
		Plug 'neovim/nvim-lspconfig'
		" JSON schema
		" Plug 'b0o/schemastore.nvim'  
		Plug 'jose-elias-alvarez/null-ls.nvim'
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
" 		Plug 'morhetz/gruvbox'

		if v:version >= 802
			if g:vimrc_use_coc
				" Use release branch (recommend)
				Plug 'neoclide/coc.nvim', {'branch': 'release'}
				Plug 'antoinemadec/coc-fzf'
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
	" FZF :Commits依赖vim-fugitive
	Plug 'tpope/vim-fugitive'
	" Plug 'MattesGroeger/vim-bookmarks'
	if has('nvim') || v:version >= 802
		Plug 'pechorin/any-jump.vim'
		Plug 'ojroques/vim-oscyank', {'branch': 'main'}
		" vnoremap <leader>c :OSCYank<CR>
	endif
	if has('terminal')
		source ~/.vim/vimrc.d/floaterm.vim
	endif
	source ~/.vim/vimrc.d/ai.vim
	source ~/.vim/vimrc.d/cpp.vim
	source ~/.vim/vimrc.d/golang.vim
	source ~/.vim/vimrc.d/java.vim
	Plug 'lambdalisue/doctest.vim'
	augroup doctest
	  autocmd! *
	  autocmd QuickFixCmdPost lDoctest nested lwindow
	augroup END

	source ~/.vim/vimrc.d/markdown.vim
	if has('nvim') || v:version >= 802
		source ~/.vim/vimrc.d/fzf/fzf.vim
		source ~/.vim/vimrc.d/jupyter.vim
	endif
	Plug 'whonore/Coqtail'
	source ~/.vim/vimrc.d/latex.vim
	source ~/.vim/vimrc.d/asynctasks.vim
	source ~/.vim/vimrc.d/yank.vim
	" codenote.vim depends on fzf.vim
	source ~/.vim/vimrc.d/codenote.vim
endif

" Initialize plugin system
call plug#end()

if glob(g:vim_plug_dir) == ""
	let g:no_plug = 1
	finish
endif

" 默认主题不显示colorcolumn
set colorcolumn=80,120
autocmd FileType org,markdown,txt setlocal colorcolumn=

if v:version >= 802
	if g:vimrc_use_coc
		source ~/.vim/vimrc.d/coc.vim
	endif
endif
if !has("nvim") || g:nvim_compatibility_with_vim
	if has("termguicolors") && g:vimrc_use_true_color
		set termguicolors
	endif
	
	let g:nord_uniform_diff_background = 1
	let g:dracula_high_contrast_diff = 1

	set background=dark
	if v:version >= 800
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
else
endif

if has('nvim') || v:version >= 801
	let g:AutoPairs = autopairs#AutoPairsDefine([
			\ {"open": "<", "close": ">", "filetype": ["html"]}
			\ ]) " This is a filetype-specific mapping
endif

if has('nvim') || v:version >= 802
	hi CocCursorRange guibg=#b16286 guifg=#ebdbb2
	source 	~/.vim/vimrc.d/project.vim
endif
