local plugins_setup = require("plugins_setup")

return {
	-- Alternatives: https://github.com/Tsuzat/NeoSolarized.nvim
	{
		"ishan9299/nvim-solarized-lua",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 2000,
		config = function()
			-- Reset coc.nvim highlight after colorscheme loaded
			-- See: https://github.com/neoclide/coc.nvim/issues/4857
			vim.cmd("colorscheme solarized")
		end,
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
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							ib = "@block.inner",
							ab = "@block.outer",
							ic = "@class.inner",
							ac = "@class.outer",
							["if"] = "@function.inner",
							af = "@function.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]b"] = "@block.outer",
							["]f"] = "@function.outer",
							["]]"] = { query = "@class.outer", desc = "Next class start" },
						},
						goto_next_end = {
							["]B"] = "@block.outer",
							["]F"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[b"] = "@block.outer",
							["[f"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[B"] = "@block.outer",
							["[F"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
		dependencies = "nvim-treesitter/nvim-treesitter",
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
			-- "benfowler/telescope-luasnip.nvim",
			"2kabhishek/nerdy.nvim",
			"albenisolmos/telescope-oil.nvim",
		},
		config = plugins_setup.telescope,
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	-- nerdfont cheatsheet: https://www.nerdfonts.com/cheat-sheet
	{
		"2kabhishek/nerdy.nvim",
		cmd = "Nerdy",
	},
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
	-- Alternatives:
	-- https://github.com/jedrzejboczar/possession.nvim
	{
		"rmagatti/auto-session",
		opts = {
			silent_restore = false,
			log_level = "error",
			args_allow_single_directory = false, -- boolean Follow normal sesion save/load logic if launched with a single directory as the only argument
			auto_session_enable_last_session = false,
			auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
			auto_session_enabled = true,
			auto_save_enabled = nil,
			auto_restore_enabled = nil,
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "~/.config", "~/.vim", "~/vimrc" },
			auto_session_use_git_branch = nil,
			-- the configs below are lua only
			bypass_session_save_file_types = nil,

			cwd_change_handling = nil, -- 不要监听文件夹切换事件: 不在cd后自动切换会话

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
	-- A graphical display window manager in neovim
	-- {'altermo/nxwm',branch='x11'},
	{
		"sourcegraph/sg.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
		},
		config = function()
			vim.keymap.set("n", "<leader>sg", function()
				require("sg.extensions.telescope").fuzzy_search_results()
			end)
		end,
		-- If you have a recent version of lazy.nvim, you don't need to add this!
		build = "nvim -l build/init.lua",
	},

	-- find and replace
	{
		"brooth/far.vim",
		cmd = { "Far", "Farf", "Farp", "Farr" },
	},
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = { "Spectre" },
		-- NOTE: do not add opts, it will break the UI behaviors
	},
	{
		"ray-x/sad.nvim",
		dependencies = {
			"ray-x/guihua.lua",
		},
		cmd = { "Sad" },
		config = function()
			require("sad").setup({
				height_ratio = 0.8, -- height ratio of sad window when split horizontally
				width_ratio = 0.8, -- height ratio of sad window when split vertically
			})
		end,
	},
	{
		"ray-x/guihua.lua",
		build = "cd lua/fzy && make",
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {},
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	},
	-- {
	-- 	"amitds1997/remote-nvim.nvim",
	-- 	version = "*", -- Pin to GitHub releases
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim", -- For standard functions
	-- 		"MunifTanjim/nui.nvim", -- To build the plugin UI
	-- 		"nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
	-- 	},
	-- 	config = true,
	-- },
}
