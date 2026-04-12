if vim.g.vimrc_lsp == "nvim-lsp" then
	local lsp_init = require("lsp.init")
	-- try plugins in https://nvimdev.github.io
	return {
		{
			"nvimtools/none-ls.nvim",
			config = function()
				local null_ls = require("null-ls")
				local sources = {
					null_ls.builtins.diagnostics.pylint,
					null_ls.builtins.diagnostics.cppcheck.with({
						args = {
							"--enable=warning,style,performance,portability",
							"--suppress=missingIncludeSystem",
							"--language=c++",
							"--template=gcc",
							"$FILENAME",
						},
						runtime_condition = function(params)
							if not params.bufname or params.bufname == "" then
								return false
							end
							return #params.content <= 2000
						end,
					}),
				}
				null_ls.setup({
					sources = sources,
				})
			end,
		},
		{
			"SmiteshP/nvim-navic",
			opts = {
				icons = {
					File = " ",
					Module = " ",
					Namespace = " ",
					Package = " ",
					Class = " ",
					Method = " ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = " ",
					Interface = " ",
					Function = " ",
					Variable = " ",
					Constant = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
					EnumMember = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
				},
				highlight = true,
				separator = " > ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				safe_output = true,
			},
		},
		{
			"jiangyinzuo/nvim-navic-note",
			dependencies = {
				"neovim/nvim-lspconfig",
				"SmiteshP/nvim-navic",
			},
			config = function()
				require("navic_note").setup({
					notes_root = vim.fn.expand("~/.notes"),
					keymap = "<leader>nv",
					create_default_keymap = true,
					auto_set_winbar = true,
				})
			end,
		},
		{
			"neovim/nvim-lspconfig",
			-- event 若设为"VimEnter"，可能导致
			-- 1) 启动时打开的文件无法自动启动lsp，需要:e才能启动
			-- 2) auto-session加载时报错 "no fold found"
			-- 3) treesitter 第一个文件的foldexpr失效
			-- 4) treesitter渲染有延迟
			priority = 500,
			dependencies = {
				"SmiteshP/nvim-navic",
				"p00f/clangd_extensions.nvim",
			},
			config = lsp_init.lspconfig,
		},
		{
			"nvimdev/lspsaga.nvim",
			event = "LspAttach",
			config = function()
				require("lspsaga").setup({
					symbol_in_winbar = {
						-- use lsp-progress.nvim
						enable = false,
					},
					lightbulb = {
						enable = true,
						sign = true,
						virtual_text = false,
						ignore = {
							clients = { "jdtls", "marksman" },
						},
					},
				})
			end,
			dependencies = {
				"nvim-treesitter/nvim-treesitter", -- optional
				"nvim-tree/nvim-web-devicons", -- optional
			},
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
							and ("[" .. client_name .. "] " .. spinner .. " " .. table.concat(series_messages, ", "))
						or nil
				end,
				-- Format (final) message.
				format = function(client_messages)
					return #client_messages > 0 and (table.concat(client_messages, " ")) or ""
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
			},
		},
		-- alternative: "hedyhli/outline.nvim",
		{
			"stevearc/aerial.nvim",
			-- Optional dependencies
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("aerial").setup({})
				vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>")
			end,
		},
		{
			"antosha417/nvim-lsp-file-operations",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
			},
			config = function()
				require("lsp-file-operations").setup()
			end,
		},
	}
else
	return {
		{
			"neoclide/coc.nvim",
			branch = "release",
			event = "UIEnter",
			init = function()
				vim.cmd([[source ~/.vim/vimrc.d/coc.vim]])
			end,
		},
	}
end
