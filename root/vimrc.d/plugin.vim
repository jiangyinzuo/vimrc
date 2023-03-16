""""""""""""""""""""""""" Plugin Config """""""""""""""""""""""""""""
let g:enable_symbol_line = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
Plug 'junegunn/vader.vim'

" Test wrapper
Plug 'vim-test/vim-test'
let test#strategy = "asyncrun_background_term"
let test#python#pytest#executable = 'python3 -m pytest'

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
 
Plug 'markonm/traces.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

if !exists('g:vscode')
	if has('nvim') && !g:nvim_compatibility_with_vim
		Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

		Plug 'nvim-lualine/lualine.nvim'
		" If you want to have icons in your statusline choose one of these
		Plug 'kyazdani42/nvim-web-devicons'
		Plug 'linrongbin16/lsp-progress.nvim'

		Plug 'williamboman/mason.nvim'
		Plug 'neovim/nvim-lspconfig'
		" Plug 'b0o/schemastore.nvim'  " JSON schema
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
		Plug 'tomasiser/vim-code-dark'
		source ~/vimrc.d/coc.vim
		source ~/vimrc.d/leaderf.vim
		Plug 'puremourning/vimspector'
		let g:vimspector_enable_mappings='HUMAN'
		let g:vimspector_base_dir = $HOME . '/.vim'
	end

	Plug 'airblade/vim-gitgutter'
	" Plug 'MattesGroeger/vim-bookmarks'
	Plug 'ojroques/vim-oscyank', {'branch': 'main'}
	" vnoremap <leader>c :OSCYank<CR>
	
	Plug 'voldikss/vim-floaterm'
	let g:floaterm_width = 0.8
	let g:floaterm_height = 0.8
	
	" executable() is slow
	source ~/vimrc.d/fzf.vim
	source ~/vimrc.d/cpp.vim
	" source ~/vimrc.d/go.vim
	source ~/vimrc.d/markdown.vim
	source ~/vimrc.d/latex.vim
	source ~/vimrc.d/asynctasks.vim
	
	Plug 'SirVer/ultisnips'
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsJumpBackwardTrigger = "<c-j>"
	let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

	Plug 'honza/vim-snippets'
end

" Initialize plugin system
call plug#end()

if !has("nvim") || g:nvim_compatibility_with_vim
	colorscheme codedark
	hi SpecialKey ctermfg=darkgray guifg=gray70
else
end
