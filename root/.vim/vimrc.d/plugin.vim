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
call plug#begin('~/.vim/plugged')

" Test framework
" Plug 'junegunn/vader.vim'

" Test wrapper
Plug 'vim-test/vim-test'
let test#strategy = "asyncrun_background_term"
let test#python#pytest#executable = 'python3 -m pytest'
let test#rust#cargotest#test_options = { 'nearest': ['--', '--nocapture', '--exact'], 'file': [] }

if has('nvim') || v:version >= 900
	" Github Coplit Support
	" https://docs.github.com/en/copilot/getting-started-with-github-copilot/getting-started-with-github-copilot-in-neovim?platform=linux
	Plug 'github/copilot.vim'
	" use <C-x> to auto complete github copilot
	" imap <silent><script><expr> <C-x> copilot#Accept("\<CR>")
	" let g:copilot_no_tab_map = v:true
endif

" Plug 'LunarWatcher/auto-pairs'
" let g:AutoPairsMapBS = 1

" similar Plugin: Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#s_next = 1
" default s: delete [count] charaters and start insert
map s <Plug>Sneak_s
map S <Plug>Sneak_S
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
 
if has('nvim') || v:version >= 810
	Plug 'markonm/traces.vim'
endif

" use coc.nvim: https://github.com/neoclide/coc.nvim/wiki/Multiple-cursors-support
" Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
au FileType gitcommit let b:EditorConfig_disable = 1

if !exists('g:vscode')
	if has('nvim') || v:version >= 800
		Plug 'SirVer/ultisnips'
	endif

	Plug 'preservim/tagbar'
	" See: https://github.com/liuchengxu/vista.vim/issues/462
	Plug 'liuchengxu/vista.vim'
	" Plug 'samoshkin/vim-mergetool'

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
" 		Plug 'dracula/vim', { 'as': 'dracula' }
		Plug 'tomasiser/vim-code-dark'
" 		Plug 'morhetz/gruvbox'

		if v:version >= 820
			source ~/.vim/vimrc.d/coc.vim
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
		if v:version >= 800
			source ~/.vim/vimrc.d/leaderf.vim
		endif
	endif

	Plug 'airblade/vim-gitgutter'
	let g:gitgutter_sign_priority = 10
	" FZF :Commits依赖vim-fugitive
	Plug 'tpope/vim-fugitive'
	" Plug 'MattesGroeger/vim-bookmarks'
	if has('nvim') || v:version >= 820
		Plug 'ojroques/vim-oscyank', {'branch': 'main'}
		" vnoremap <leader>c :OSCYank<CR>
	endif
	if has('terminal')
		Plug 'voldikss/vim-floaterm'
		let g:floaterm_width = 0.8
		let g:floaterm_height = 0.8
	endif	

	source ~/.vim/vimrc.d/cpp.vim
	source ~/.vim/vimrc.d/golang.vim
	source ~/.vim/vimrc.d/java.vim
	source ~/.vim/vimrc.d/markdown.vim
	if has('nvim') || v:version >= 820
		source ~/.vim/vimrc.d/fzf.vim
		source ~/.vim/vimrc.d/jupyter.vim
	endif
	Plug 'whonore/Coqtail'
	source ~/.vim/vimrc.d/latex.vim
	source ~/.vim/vimrc.d/asynctasks.vim
	source ~/.vim/vimrc.d/codenote.vim
endif

" Initialize plugin system
call plug#end()

if !has("nvim") || g:nvim_compatibility_with_vim
	if (has("termguicolors") && exists('$WSLENV'))
		set termguicolors
	endif
	colorscheme codedark
" 	hi SpecialKey ctermfg=darkgray guifg=gray70
else
endif

if has('nvim') || v:version >= 820
	source 	~/.vim/vimrc.d/project.vim
endif
