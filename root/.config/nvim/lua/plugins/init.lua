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
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			-- bigfile = { enabled = true },
			-- dashboard = { enabled = true },
			-- explorer = { enabled = true },
			-- BUG: extui + snack.nvim input is buggy when using vim.lsp.buf.rename()
			input = { enabled = true, border = "rounded" },
			-- picker = { enabled = true },
			-- notifier = { enabled = true },
			-- quickfile = { enabled = true },
			-- scope = { enabled = true },
			-- scroll = { enabled = true },
			-- statuscolumn = { enabled = true },
			-- words = { enabled = true },
		},
		cond = false,
	},
	-- nerdfont cheatsheet: https://www.nerdfonts.com/cheat-sheet
	{
		"2kabhishek/nerdy.nvim",
		cmd = "Nerdy",
		opts = {
			max_recents = 30, -- Configure recent icons limit
			add_default_keybindings = false, -- Add default keybindings
			copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
		},
	},
	{
		"brianhuster/unnest.nvim",
	},
	{
		"sindrets/diffview.nvim",
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
	{
		"echasnovski/mini.files",
		version = false,
		opts = {
			-- General options
			options = {
				-- Whether to delete permanently or move into module-specific trash
				permanent_delete = true,
				-- Whether to use for editing directories
				use_as_default_explorer = false,
			},
		},
		config = function()
			local MiniFiles = require("mini.files")
			-- create a custom command to open the file explorer
			vim.api.nvim_create_user_command("MiniFiles", function()
				MiniFiles.open(vim.fn.expand("%:p:h"))
			end, { desc = "Open file explorer in current directory" })

			local show_dotfiles = true

			local filter_show = function(fs_entry)
				return true
			end

			local filter_hide = function(fs_entry)
				return not vim.startswith(fs_entry.name, ".")
			end

			local toggle_dotfiles = function()
				show_dotfiles = not show_dotfiles
				local new_filter = show_dotfiles and filter_show or filter_hide
				MiniFiles.refresh({ content = { filter = new_filter } })
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local buf_id = args.data.buf_id
					-- Tweak left-hand side of mapping to your liking
					vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle dotfiles" })
					vim.keymap.set("n", "<leader>ff", function()
						MiniFiles.close()
						require("telescope.builtin").find_files({ search_dirs = { MiniFiles.get_latest_path() } })
					end, {
						buffer = buf_id,
						desc = "Telescope find files",
					})
				end,
			})
		end,
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
	-- alternatives: brooth/far.vim, nvim-pack/nvim-spectre
	{
		"MagicDuck/grug-far.nvim",
		-- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
		-- additional lazy config to defer loading is not really needed...
		config = function()
			-- optional setup call to override plugin options
			-- alternatively you can set options with vim.g.grug_far = { ... }
			require("grug-far").setup({
				-- options, see Configuration section below
				-- there are no required options atm
			})
		end,
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
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			preview = {
				auto_preview = false,
			},
		},
	},
}
