require("nvim-treesitter.configs").setup {
	-- 安装 language parser
	-- :TSInstallInfo 命令查看支持的语言
	ensure_installed = { "cpp", "lua", "vim", "python", "rust" },
	-- 启用代码高亮模块
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>rg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.oldfiles, {})
vim.api.nvim_set_keymap(
	"n",
	"<leader>ft",
	":Telescope file_browser<cr>",
	{ noremap = true }
)

local fb_actions = require "telescope._extensions.file_browser.actions"
local telescope = require("telescope")
telescope.setup({
	extensions = {
		file_browser = {
			hijack_netrw = false,
			depth = false,
			mappings = {
				["i"] = {
					["<A-c>"] = fb_actions.create,
					["<A-e>"] = fb_actions.create_from_prompt, -- 创建文件（夹）
					["<A-r>"] = fb_actions.rename,
					["<A-m>"] = fb_actions.move,
					["<A-y>"] = fb_actions.copy,
					["<A-d>"] = fb_actions.remove,
					["<C-o>"] = fb_actions.open,
					["<C-g>"] = fb_actions.goto_parent_dir,
					["<C-e>"] = fb_actions.goto_home_dir,
					["<C-w>"] = fb_actions.goto_cwd,
					["<C-t>"] = fb_actions.change_cwd,
					["<C-f>"] = fb_actions.toggle_browser,
					["<C-h>"] = fb_actions.toggle_hidden,
					["<C-s>"] = fb_actions.toggle_all,
				},
			}
		}
	}
})
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension "file_browser"

require("mason").setup {
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
}

require("lsp")

require('lsp-progress').setup({
	-- Spinning icons.
	spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
	-- Spinning update time in milliseconds.
	spin_update_time = 200,
	-- Last message cached decay time in milliseconds.
	--
	-- Message could be really fast(appear and disappear in an
	-- instant) that user cannot even see it, thus we cache the last message
	-- for a while for user view.
	decay = 1000,
	-- User event name.
	event = "LspProgressStatusUpdated",
	-- Event update time limit in milliseconds.
	--
	-- Sometimes progress handler could emit many events in an instant, while
	-- refreshing statusline cause too heavy synchronized IO, so we limit the
	-- event rate to reduce this cost.
	event_update_time_limit = 125,
	--- Max progress string length, by default -1 is unlimit.
	max_size = -1,
	-- Format series message.
	--
	-- By default it looks like: `formatting isort (100%) - done`.
	--
	-- @param title      Message title.
	-- @param message    Message body.
	-- @param percentage Progress in percentage numbers: [0%-100%].
	-- @param done       Indicate if this message is the last one in progress.
	-- @return           A nil|string|table value. The returned value will be
	--                   passed to function `client_format` as one of the
	--                   `series_messages` array, or ignored if return nil.
	series_format = function(title, message, percentage, done)
		local builder = {}
		local has_title = false
		local has_message = false
		if title and title ~= "" then
			table.insert(builder, title)
			has_title = true
		end
		if message and message ~= "" then
			table.insert(builder, message)
			has_message = true
		end
		if percentage and (has_title or has_message) then
			table.insert(builder, string.format("(%.0f%%%%)", percentage))
		end
		if done and (has_title or has_message) then
			table.insert(builder, "- done")
		end
		return table.concat(builder, " ")
	end,
	-- Format client message.
	--
	-- By default it looks like:
	-- `[null-ls] ⣷ formatting isort (100%) - done, formatting black (50%)`.
	--
	-- @param client_name     Client name.
	-- @param spinner         Spinner icon.
	-- @param series_messages Series messages array.
	-- @return                A nil|string|table value. The returned value will
	--                        be passed to function `format` as one of the
	--                        `client_messages` array, or ignored if return nil.
	client_format = function(client_name, spinner, series_messages)
		return #series_messages > 0
				and ("[" .. client_name .. "] " .. spinner .. " " .. table.concat(
					series_messages,
					", "
				))
				or nil
	end,
	-- Format (final) message.
	--
	-- By default it looks like:
	-- ` LSP [null-ls] ⣷ formatting isort (100%) - done, formatting black (50%)`
	--
	-- @param client_messages Client messages array.
	-- @return                A nil|string|table value. The returned value will be
	--                        returned from `progress` API.
	format = function(client_messages)
		local sign = " LSP" -- nf-fa-gear \uf013
		return #client_messages > 0
				and (sign .. " " .. table.concat(client_messages, " "))
				or sign
	end,
	--- Enable debug.
	debug = false,
	--- Print log to console(command line).
	console_log = true,
	--- Print log to file.
	file_log = false,
	-- Log file to write, work with `file_log=true`.
	-- For Windows: `$env:USERPROFILE\AppData\Local\nvim-data\lsp-progress.log`.
	-- For *NIX: `~/.local/share/nvim/lsp-progress.log`.
	file_log_name = "lsp-progress.log",
})

require('colorscheme')

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'solarized',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		-- 'diff' is slow
		lualine_b = { 'branch', 'diagnostics', 'filename' },
		lualine_c = {
			-- invoke `progress` to get lsp progress status.
			require("lsp-progress").progress,
		},
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

