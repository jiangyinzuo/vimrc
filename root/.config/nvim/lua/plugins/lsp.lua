local lualine = {
	'nvim-lualine/lualine.nvim',
}

if vim.g.vimrc_lsp == 'nvim-lsp' then
	lualine.dependencies = {
		"neovim/nvim-lspconfig",
		"linrongbin16/lsp-progress.nvim",
	}
	local lsp = require('lsp.init')
	-- try plugins in https://nvimdev.github.io
	return {
		{
			"neovim/nvim-lspconfig",
			priority = 500,
			dependencies = {
				'SmiteshP/nvim-navic',
				'p00f/clangd_extensions.nvim'
			},
			config = lsp.lspconfig,
		},
		{
			"linrongbin16/lsp-progress.nvim",
			opts = {
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
				client_format = function(client_name, spinner, series_messages)
					return #series_messages > 0
							and ("[" .. client_name .. "] " .. spinner .. " " .. table.concat(
								series_messages,
								", "
							))
							or nil
				end,
				-- Format (final) message.
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
			}
		},
		{
			'nvimtools/none-ls.nvim',
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						null_ls.builtins.formatting.stylua,
					},
				})
			end
		},
		{
			-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
			"folke/neodev.nvim",
			opts = {},
			ft = { 'lua' },
			priority = 501
		},
		{
			"hedyhli/outline.nvim",
			lazy = true,
			cmd = { "Outline", "OutlineOpen" },
			opts = {
				-- Your setup opts here
			},
		},
		{
			'mrcjkb/rustaceanvim',
			version = '^4', -- Recommended
			ft = { 'rust' },
		},
		{
			"ray-x/go.nvim",
			dependencies = { -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("go").setup()
			end,
			event = { "CmdlineEnter" },
			ft = { "go", 'gomod' },
			-- 该命令在网络环境差的情况下可能会卡顿，故手动执行
			-- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
		},
		{
			'mfussenegger/nvim-jdtls',
		},
		lualine,
	}
else
	lualine.dependencies = {
		"neoclide/coc.nvim",
	}
	return {
		{
			'neoclide/coc.nvim',
			branch = 'release',
			init = function()
				vim.cmd [[source ~/.vim/vimrc.d/coc.vim]]
			end,
		},
		lualine,
	}
end
