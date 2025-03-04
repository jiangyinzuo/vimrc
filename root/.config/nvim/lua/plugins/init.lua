local plugins_setup = require("plugins_setup")
local has_typst_executable = require("detect").has_typst_executable
local has_quarto_executable = require("detect").has_quarto_executable

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return vim.fn.fnamemodify(dir, ":~")
	else
		-- If there is no current directory (e.g. over ssh), just show the buffer name
		return vim.api.nvim_buf_get_name(0)
	end
end

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
		config = function()
			require("nvim-treesitter.configs").setup({
				-- 安装 language parser
				-- :TSInstallInfo 命令查看支持的语言
				ensure_installed = {
					"c",
					"cpp",
					"go",
					"lua",
					"vim",
					"vimdoc",
					"python",
					"rust",
					"html",
					"query",
					"markdown",
					"markdown_inline",
				},
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- 启用代码高亮模块
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				-- https://github.com/RRethy/nvim-treesitter-endwise
				endwise = {
					enable = false, -- nvim-treesitter-endwise is not maintained
				},
				-- https://github.com/andymass/vim-matchup
				matchup = {
					enable = true, -- mandatory, false will disable the whole extension
					-- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
					-- [options]
				},
			})
		end,
		dependencies = {
			-- "RRethy/nvim-treesitter-endwise",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 30, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
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
							-- ["]b"] = "@block.outer",
							["]f"] = "@function.outer",
							["]]"] = { query = "@class.outer", desc = "Next class start" },
						},
						goto_next_end = {
							-- ["]B"] = "@block.outer",
							["]F"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							-- ["[b"] = "@block.outer",
							["[f"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							-- ["[B"] = "@block.outer",
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
		"windwp/nvim-ts-autotag",
		opts = {},
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
		"akinsho/git-conflict.nvim",
		version = "*",
		config = function()
			require("git-conflict").setup()
			vim.api.nvim_create_autocmd("User", {
				pattern = "GitConflictDetected",
				callback = function()
					vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
				end,
			})
		end,
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
		opts = {
			highlight = {
				multiline = true,
				keyword = "bg",
				-- NOTE(jiangyinzuo): highlight this comment
				pattern = { [[\s(KEYWORDS)\(.+\):]], [[\s(KEYWORDS):]] }, -- pattern or table of patterns, used for highlightng (vim regex, \v\C)
			},
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--max-columns=0",
				},
				-- regex that will be used to match keywords.
				-- don't replace the (KEYWORDS) placeholder:
				pattern = [[\b(KEYWORDS)(\(.+\))?:]], -- ripgrep regex
				-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
			},
		},
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
				load_on_setup = false, -- Initialize on startup (requires Telescope)
				buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
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
		cmd = { "Oil" },
		config = function()
			local detail = false
			require("oil").setup({
				default_file_explorer = false,
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = false,
				},
				keymaps = {
					["gd"] = {
						desc = "Toggle file detail view",
						callback = function()
							detail = not detail
							if detail then
								require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
							else
								require("oil").set_columns({ "icon" })
							end
						end,
					},
				},
				win_options = {
					winbar = "%!v:lua.get_oil_winbar()",
				},
			})
		end,
	},
	-- A graphical display window manager in neovim
	-- {'altermo/nxwm',branch='x11'},
	-- {
	-- 	"sourcegraph/sg.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
	-- 	},
	-- 	config = function()
	-- 		vim.keymap.set("n", "<leader>sg", function()
	-- 			require("sg.extensions.telescope").fuzzy_search_results()
	-- 		end)
	-- 	end,
	-- 	-- If you have a recent version of lazy.nvim, you don't need to add this!
	-- 	build = "nvim -l build/init.lua",
	-- },

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
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
		},
		ft = { "markdown", "Avante" },
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	},
	{
		"chomosuke/typst-preview.nvim",
		cond = has_typst_executable,
		ft = "typst",
		build = function()
			require("typst-preview").update()
		end,
	},
	{
		"kaarmu/typst.vim",
		cond = has_typst_executable,
		ft = "typst",
	},
	{
		"quarto-dev/quarto-nvim",
		cond = has_quarto_executable,
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
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
	{
		"gregorias/coerce.nvim",
		event = "VeryLazy",
		dependencies = {
			"gregorias/coop.nvim",
		},
		config = true,
	},
	{
		"goerz/jupytext.nvim",
		event = "VeryLazy",
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			preview = {
				auto_preview = false,
			},
		},
	},
}
