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
	}
}
