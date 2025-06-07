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
	-- nerdfont cheatsheet: https://www.nerdfonts.com/cheat-sheet
	{
		"2kabhishek/nerdy.nvim",
		cmd = "Nerdy",
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			github = {
				-- The template URL to use when downloading assets from GitHub.
				-- The placeholders are the following (in order):
				-- 1. The repository (e.g. "rust-lang/rust-analyzer")
				-- 2. The release version (e.g. "v0.3.0")
				-- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
				download_url_template = "https://cors.isteed.cc/github.com/%s/releases/download/%s/%s",
			},
		},
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
		cond = vim.g.vimrc_lsp == 'nvim-lsp' and has_quarto_executable,
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
		config = function()
			require("coerce").setup()
			local split_keyword = require("coerce.case").split_keyword
			require("coerce").register_case({
				keymap = "t",
				case = function(str)
					local parts = split_keyword(str)
					-- 不需要大写的单词列表
					local no_cap_words = {
						"a",
						"an",
						"the",
						"and",
						"or",
						"but",
						"for",
						"nor",
						"as",
						"at",
						"by",
						"in",
						"of",
						"on",
						"to",
						"with",
					}
					parts = vim.tbl_map(function(part)
						-- 如果单词在no_cap_words列表中且不是第一个单词，保持小写
						if vim.tbl_contains(no_cap_words, part:lower()) and part ~= parts[1] then
							return part:lower()
						end
						return part:sub(1, 1):upper() .. part:sub(2):lower()
					end, parts)
					return table.concat(parts, " ")
				end,
				description = "Title Case",
			})
		end,
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
