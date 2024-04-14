local plugins_setup = require('plugins_setup')

return {
	{
		"ishan9299/nvim-solarized-lua",
		lazy = false,  -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
	},
	{
		'nvim-tree/nvim-web-devicons'
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = plugins_setup.nvim_treesitter,
		dependencies = {
			'RRethy/nvim-treesitter-endwise'
		}
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		keys = {
			"<leader>fb",
			"<leader>ff",
			"<leader>fh",
			"<leader>ft",
			"<leader>rg",
		},
		cmd = { "Telescope" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"aaronhallaert/advanced-git-search.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"rmagatti/session-lens",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-bibtex.nvim",
		},
		config = plugins_setup.telescope,
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{
		"williamboman/mason.nvim",
		config = plugins_setup.mason,
	},
	{
		'sindrets/diffview.nvim',
	},
	{
		"aaronhallaert/advanced-git-search.nvim",
		dependencies = {
			'sindrets/diffview.nvim'
		},
	},
	{
		"luckasRanarison/nvim-devdocs",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = {
			"DevdocsOpen",
			"DevdocsFetch",
			"DevdocsToggle",
			"DevdocsUpdate",
			"DevdocsInstall",
			"DevdocsOpenFloat",
			"DevdocsUninstall",
			"DevdocsUpdateAll",
			"DevdocsKeywordprg",
			"DevdocsOpenCurrent",
			"DevdocsOpenCurrentFloat",
		},
		opts = {}
	},
	-- neovim 0.10.0 has builtin comments, but Comment.nvim is better
	-- :h commenting
	{
		'numToStr/Comment.nvim',
		opts = {}
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
		}
	},
	{
		'rmagatti/auto-session',
		config = plugins_setup.auto_session,
	},
	{
		'rmagatti/session-lens',
		dependencies = {
			'rmagatti/auto-session'
		}
	},
	-- oil.nvim implements WillRenameFiles Request that neovim LSP does not support.
	-- See also:
	-- https://github.com/neovim/neovim/issues/20784
	-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_willRenameFiles
	{
		'stevearc/oil.nvim',
		opts = {
			default_file_explorer = false,
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = false,
			}
		}
	}
}
