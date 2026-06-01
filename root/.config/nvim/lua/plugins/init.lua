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
			-- ToggleTerm REPL sender
			--
			-- 语义：
			--   <leader>sl       当前行 -> terminal 1
			--   2<leader>sl      当前行 -> terminal 2
			--
			--   <leader>s_       当前行 -> terminal 1
			--   2<leader>s_      当前行 -> terminal 2
			--
			--   <leader>sip      inner paragraph -> terminal 1
			--   3<leader>sip     inner paragraph -> terminal 3
			--
			--   visual <leader>s 精确发送 visual selection
			--   visual <leader>S 按整行发送 visual lines
			--
			-- 设计：
			--   1. normal mode 的 count 被解释为 terminal id。
			--   2. 不支持 Vim operator 的 count 重复语义。
			--   3. operatorfunc 里只发送，不打开 terminal，避免 E565。
			--   4. terminal 在进入 g@ operator 前打开。

			require("toggleterm").setup({
				direction = "vertical",
				size = 80,
				persist_size = false,
				shade_terminals = false,
				start_in_insert = false,
			})

			local toggleterm = require("toggleterm")
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

			-- pending_tid 在 keymap 阶段设置。
			-- operatorfunc 阶段不要再读 vim.v.count。
			local pending_tid = 1
			local pending_ready = false

			local function count_as_tid()
				return vim.v.count > 0 and vim.v.count or 1
			end

			local function repl_cmd_for_current_buffer()
				return repl_cmd_by_ft[vim.bo.filetype] or default_repl_cmd
			end

			local function term_is_open(term)
				if term == nil then
					return false
				end

				if type(term.is_open) == "function" then
					local ok, opened = pcall(function()
						return term:is_open()
					end)

					if ok then
						return opened
					end
				end

				return term.job_id ~= nil
			end

			local function ensure_repl_terminal(tid)
				local src_win = vim.api.nvim_get_current_win()

				local term = terminal.get(tid, true)

				if term == nil then
					term = Terminal:new({
						id = tid,
						cmd = repl_cmd_for_current_buffer(),
						direction = "vertical",
						hidden = true,
						close_on_exit = false,
						size = 80,
					})
				end

				if not term_is_open(term) then
					term:open()

					-- term:open() 可能切到 terminal 窗口。
					-- 切回源码窗口，保证后续 g@ motion 在源码 buffer 上执行。
					if vim.api.nvim_win_is_valid(src_win) then
						vim.api.nvim_set_current_win(src_win)
					end
				end

				return term
			end

			local function prepare_repl_for_tid(tid)
				pending_tid = tid
				pending_ready = false

				local ok, term_or_err = pcall(function()
					return ensure_repl_terminal(tid)
				end)

				if not ok then
					vim.notify(("Failed to open ToggleTerm terminal %d: %s"):format(tid, term_or_err), vim.log.levels.ERROR)
					return false
				end

				local term = term_or_err

				if term == nil or not term_is_open(term) then
					vim.notify(("Failed to open ToggleTerm terminal %d"):format(tid), vim.log.levels.ERROR)
					return false
				end

				pending_ready = true
				return true
			end

			-- 这个函数由 mapping RHS 里的 :lua 调用。
			-- 注意：这里允许打开 terminal，因为它发生在进入 g@ operator 之前。
			function _G.toggleterm_repl_prepare_operator()
				local tid = pending_tid

				if prepare_repl_for_tid(tid) then
					vim.go.operatorfunc = "v:lua.toggleterm_repl_operator"
				else
					-- 即使失败，也设置一个空 operator，避免报错。
					vim.go.operatorfunc = "v:lua.toggleterm_repl_operator"
				end
			end

			-- 这个函数由 g@ 在 motion 解析完成后调用。
			-- 注意：这里绝对不要 open/split/vsplit。
			function _G.toggleterm_repl_operator(motion_type)
				local tid = pending_tid

				if not pending_ready then
					return
				end

				local term = terminal.get(tid, true)

				if term == nil or not term_is_open(term) then
					vim.notify(("ToggleTerm terminal %d is not open; send aborted"):format(tid), vim.log.levels.WARN)
					return
				end

				toggleterm.send_lines_to_terminal(motion_type, trim_spaces, { args = tid })
			end

			local function send_to_terminal(selection_type, tid)
				tid = tid or count_as_tid()

				if not prepare_repl_for_tid(tid) then
					return
				end

				toggleterm.send_lines_to_terminal(selection_type, trim_spaces, { args = tid })
			end

			-- Normal mode: <leader>s{motion}
			--
			-- 关键点：
			--   expr=true 只负责先保存 count 到 pending_tid。
			--   RHS 使用 :<C-u> 清掉 Vim count/range。
			--   然后进入 g@ operator。
			--
			-- 这样：
			--   2<leader>sip
			-- 不会变成 2g@ip，而是：
			--   pending_tid = 2
			--   g@ip
			vim.keymap.set("n", "<leader>s", function()
				pending_tid = count_as_tid()
				return ":<C-u>lua toggleterm_repl_prepare_operator()<CR>g@"
			end, {
				expr = true,
				silent = true,
				desc = "REPL send motion to ToggleTerm",
			})

			-- Normal mode: <leader>sl
			--
			-- 不走 g@_，避免 2<leader>sl 发送 2 行。
			vim.keymap.set("n", "<leader>sl", function()
				send_to_terminal("single_line", count_as_tid())
			end, {
				desc = "REPL send current line to ToggleTerm",
			})

			-- 可选：显式 <leader>s_，等价于 operator + _。
			-- 这里也用 :<C-u> 清掉 count。
			vim.keymap.set("n", "<leader>s_", function()
				pending_tid = count_as_tid()
				return ":<C-u>lua toggleterm_repl_prepare_operator()<CR>g@_"
			end, {
				expr = true,
				silent = true,
				desc = "REPL send current line by motion to ToggleTerm",
			})

			-- Visual mode: 精确 visual selection
			vim.keymap.set("x", "<leader>s", function()
				send_to_terminal("visual_selection", count_as_tid())
			end, {
				desc = "REPL send visual selection to ToggleTerm",
			})

			-- Visual mode: 按整行发送 visual lines
			vim.keymap.set("x", "<leader>S", function()
				send_to_terminal("visual_lines", count_as_tid())
			end, {
				desc = "REPL send visual lines to ToggleTerm",
			})

			-- 手动打开当前 tid 的 terminal。
			vim.keymap.set("n", "<leader>so", function()
				prepare_repl_for_tid(count_as_tid())
			end, {
				desc = "REPL open ToggleTerm terminal",
			})
		end,
	},
}
