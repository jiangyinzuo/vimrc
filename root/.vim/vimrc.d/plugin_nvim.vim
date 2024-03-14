" Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'ishan9299/nvim-solarized-lua'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'

if g:vimrc_lsp == 'nvim-lsp'
	Plug 'neovim/nvim-lspconfig'
	Plug 'linrongbin16/lsp-progress.nvim'
endif

Plug 'williamboman/mason.nvim'
" JSON schema
" Plug 'b0o/schemastore.nvim'
" Replace jose-elias-alvarez/null-ls.nvim
" Plug 'nvimtools/none-ls.nvim'
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
Plug 'nvim-telescope/telescope-media-files.nvim'

" completion(use ultisnips)
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary', 'on': [
			\ 'CopilotChat',
			\  'CopilotChatFixDiagnostic',
			\  'CopilotChatFix',
			\  'CopilotChatOpen',
			\  'CopilotChatReset',
			\  'CopilotChatOptimize',
			\  'CopilotChatTests',
			\  'CopilotChatExplain',
			\  'CopilotChatDebugInfo',
			\  'CopilotChatClose',
			\  'CopilotChatDocs',
			\  'CopilotChatCommit',
			\  'CopilotChatCommitStaged',
			\  'CopilotChatToggle']}
