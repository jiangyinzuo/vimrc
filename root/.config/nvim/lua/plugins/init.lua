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
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {
			map_bs = false,
		},
	},
	{
		"sindrets/diffview.nvim",
	},
	-- :h commenting
	-- {
	-- 	"numToStr/Comment.nvim",
	-- 	opts = {},
	-- },
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
	-- find and replace
	{ "nvim-pack/nvim-spectre", opts = {} },
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
	{
		"jonathanforhan/nvim-glyph",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		opts = {},
		init = function()
			vim.keymap.set("i", "<C-k><C-k>", function()
				require("nvim-glyph").pick_glyph()
			end)
		end,
	},
	-- 性能可能下降
	{
		"chrisgrieser/nvim-origami",
		cond = false,
		event = "VeryLazy",
		opts = {
			autoFold = {
				enabled = false,
				kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
			},
			foldKeymaps = {
				setup = false, -- modifies `h`, `l`, and `$`
				hOnlyOpensOnFirstColumn = false,
			},
		}, -- needed even when using default config
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup()
			-- ToggleTerm REPL sender
			--
			-- 用法：
			--   <leader>s{motion}   发送 motion 范围
			--   <leader>ss          发送当前行，类似 dd
			--   vip<leader>s        visual 精确选区发送
			--   Vjj<leader>S        visual 整行发送
			--
			--   2<leader>ss         发送当前行到 terminal 2
			--   3<leader>sip        发送 inner paragraph 到 terminal 3

			local terminal = require("toggleterm.terminal")
			local Terminal = terminal.Terminal

			local trim_spaces = false
			local default_repl_cmd = "bash"

			local repl_cmd_by_ft = {
				python = "ipython --no-autoindent",
				lua = "lua",
				sh = "bash",
				bash = "bash",
				zsh = "zsh",
				javascript = "node",
				typescript = "ts-node",
				sql = "duckdb",
				r = "R",
			}

			local pending_tid = nil

			local function repl_tid()
				return vim.v.count > 0 and vim.v.count or 1
			end

			local function repl_cmd_for_current_buffer()
				return repl_cmd_by_ft[vim.bo.filetype] or default_repl_cmd
			end

			local function ensure_repl_terminal(tid)
				local term = terminal.get(tid, true)

				if term ~= nil then
					return term
				end

				term = Terminal:new({
					count = tid,
					cmd = repl_cmd_for_current_buffer(),
					direction = "horizontal",
					hidden = true,
					close_on_exit = false,
					size = 15,
				})

				-- 这里不能在 expr mapping 阶段调用。
				-- 但在 vim.schedule() 之后调用是安全的。
				term:spawn()

				return term
			end

			local function send_to_repl(tid, selection_type)
				local term = ensure_repl_terminal(tid)

				if term == nil then
					return
				end

				require("toggleterm").send_lines_to_terminal(selection_type, trim_spaces, { args = tid })
			end

			function _G.toggleterm_repl_operator(motion_type)
				local tid = pending_tid or 1
				pending_tid = nil

				-- 关键：不要在 operatorfunc 当前调用栈里直接 spawn/send。
				-- 延后到安全时机，避开 E565。
				vim.schedule(function()
					send_to_repl(tid, motion_type)
				end)
			end

			-- Normal mode:
			--   <leader>s{motion}
			--
			-- 这里绝对不要 ensure_repl_terminal()。
			-- expr mapping 阶段只能返回按键，不要改窗口/改 buffer/termopen。
			vim.keymap.set("n", "<leader>s", function()
				pending_tid = repl_tid()
				vim.go.operatorfunc = "v:lua.toggleterm_repl_operator"
				return "g@"
			end, {
				expr = true,
				desc = "REPL send motion to ToggleTerm",
			})

			-- Normal mode:
			--   <leader>ss
			--
			-- 类似 dd，发送当前行。
			vim.keymap.set("n", "<leader>ss", function()
				pending_tid = repl_tid()
				vim.go.operatorfunc = "v:lua.toggleterm_repl_operator"
				return "g@_"
			end, {
				expr = true,
				desc = "REPL send current line to ToggleTerm",
			})

			-- Visual mode:
			--   vip<leader>s
			--
			-- visual mapping 虽然不是 expr，但为了避免 visual 状态/selection 状态下
			-- termopen 触发类似问题，也统一 schedule。
			vim.keymap.set("x", "<leader>s", function()
				local tid = repl_tid()

				vim.schedule(function()
					send_to_repl(tid, "visual_selection")
				end)
			end, {
				desc = "REPL send visual selection to ToggleTerm",
			})

			-- Visual mode:
			--   Vjj<leader>S
			--
			-- 整行发送。
			vim.keymap.set("x", "<leader>S", function()
				local tid = repl_tid()

				vim.schedule(function()
					send_to_repl(tid, "visual_lines")
				end)
			end, {
				desc = "REPL send visual lines to ToggleTerm",
			})

			-- 可选：打开当前 tid 对应的 terminal 窗口
			--
			--   <leader>so
			--   2<leader>so
			--
			-- 这个是普通 normal mapping，不是 expr mapping，所以可以 open。
			vim.keymap.set("n", "<leader>so", function()
				local tid = repl_tid()
				local term = ensure_repl_terminal(tid)

				if term ~= nil then
					term:open(15, "horizontal")
				end
			end, {
				desc = "REPL open ToggleTerm terminal",
			})

			-- 可选：重启当前 tid 对应的 terminal
			--
			--   <leader>sr
			--   2<leader>sr
			vim.keymap.set("n", "<leader>sr", function()
				local tid = repl_tid()
				local term = terminal.get(tid, true)

				if term ~= nil then
					term:shutdown()
				end

				-- 普通 mapping，可以直接 spawn。
				ensure_repl_terminal(tid)
			end, {
				desc = "REPL restart ToggleTerm terminal",
			})
		end,
	},
}
