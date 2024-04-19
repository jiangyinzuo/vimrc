local plugins_setup = require("plugins_setup")

return {
	{
		"ishan9299/nvim-solarized-lua",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 2,
		config = plugins_setup.colorscheme,
	},
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = plugins_setup.nvim_treesitter,
		dependencies = {
			"RRethy/nvim-treesitter-endwise",
		},
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
			"rmagatti/auto-session",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-bibtex.nvim",
			"benfowler/telescope-luasnip.nvim",
		},
		config = plugins_setup.telescope,
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"williamboman/mason.nvim",
		config = plugins_setup.mason,
	},
	{
		"sindrets/diffview.nvim",
	},
	{
		"aaronhallaert/advanced-git-search.nvim",
		dependencies = {
			"sindrets/diffview.nvim",
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
		opts = {},
	},
	-- neovim 0.10.0 has builtin comments, but Comment.nvim is better
	-- :h commenting
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"rmagatti/auto-session",
		opts = {
			log_level = "error",
			auto_session_enable_last_session = false,
			auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
			auto_session_enabled = true,
			auto_save_enabled = nil,
			auto_restore_enabled = nil,
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "~/.config", "~/.vim", "~/vimrc" },
			auto_session_use_git_branch = nil,
			-- the configs below are lua only
			bypass_session_save_file_types = nil,

			cwd_change_handling = {
				restore_upcoming_session = true, -- already the default, no need to specify like this, only here as an example
				pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
				post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
					require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
				end,
			},

			-- ⚠️ This will only work if Telescope.nvim is installed
			-- The following are already the default values, no need to provide them if these are already the settings you want.
			session_lens = {
				-- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
				buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
			},
		},
	},
	-- oil.nvim implements WillRenameFiles Request that neovim LSP does not support.
	-- See also:
	-- https://github.com/neovim/neovim/issues/20784
	-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_willRenameFiles
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = false,
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = false,
			},
		},
	},
}
