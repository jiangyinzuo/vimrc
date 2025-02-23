local detect = require("detect")

if vim.g.vimrc_lsp == "nvim-lsp" then
	local lsp = require("lsp.init")
	-- try plugins in https://nvimdev.github.io
	return {
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
			config = lsp.lspconfig,
		},
		{
			"ranjithshegde/ccls.nvim",
			event = "VimEnter",
			dependencies = {
				"neovim/nvim-lspconfig",
			},
		},
		-- 目前缺乏type hierarchy tree UI
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
					local sign = " LSP" -- nf-fa-gear \uf013
					return #client_messages > 0 and (sign .. " " .. table.concat(client_messages, " ")) or sign
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
		{
			"nvimtools/none-ls.nvim",
			config = function()
				local null_ls = require("null-ls")
				local sources = {
					null_ls.builtins.formatting.stylua,
					-- install via mason
					null_ls.builtins.formatting.google_java_format,
				}
				if vim.g.python_formatter == "black" then
					table.insert(sources, null_ls.builtins.formatting.black)
				end
				null_ls.setup({
					sources = sources,
				})
			end,
		},
		-- {
		-- 	-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
		-- 	"folke/neodev.nvim",
		-- 	opts = {},
		-- 	ft = { "lua" },
		-- 	priority = 501,
		-- },
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			priority = 501,
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
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
			"mrcjkb/rustaceanvim",
			cond = detect.has_rust_executable,
			-- version = "^5", -- Recommended
			lazy = false, -- This plugin is already lazy
			ft = { "rust" },
		},
		{
			-- NOTE: must ensure `go env GOPATH`/bin is in $PATH,
			-- do not use apt install gopls, whose version is (unknown) and can not be parsed by go.nvim.
			"ray-x/go.nvim",
			cond = detect.has_go_executable,
			dependencies = { -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
				"nvimtools/none-ls.nvim",
			},
			config = function()
				require("go").setup({
					verbose = false, -- debug
					lsp_semantic_highlights = false, -- do not use highlights from gopls so we can use treesitter highlight injection
					lsp_keymaps = false, -- true: use default keymaps defined in go/lsp.lua
					lsp_cfg = {
						capabilities = require("lsp").get_capabilities(),
						settings = {
							gopls = {
								semanticTokens = false, -- disable semantic string tokens so we can use treesitter highlight injection
							},
						},
					},
					-- after go.nvim's on_attach is called, then this on_attach will be called
					lsp_on_client_start = function(client, bufnr)
						local lsp_module = require("lsp")
						lsp_module.attach_navic(client, bufnr)
						lsp_module.attach_inlay_hints(client, bufnr)
					end,
					null_ls = { -- set to false to disable null-ls setup
						golangci_lint = {
							method = { "NULL_LS_DIAGNOSTICS_ON_SAVE", "NULL_LS_DIAGNOSTICS_ON_OPEN" }, -- when it should run
							-- 为了防止和项目的.golangci.yml文件配置冲突，故disable和enable为空
							disable = {}, -- linters to disable empty by default
							enable = {}, -- linters to enable; empty by default
							severity = vim.diagnostic.severity.INFO, -- severity level of the diagnostics
						},
					},
				})
				-- go.nvim
				-- require("go.null_ls").gotest(),
				-- require("go.null_ls").gotest_action(),
				require("null-ls").register(require("go.null_ls").golangci_lint())
			end,
			ft = { "go", "gomod" },
			-- 该命令在网络环境差的情况下可能会卡顿，故手动执行
			-- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
		},
		{
			"mfussenegger/nvim-jdtls",
		},
		-- {
		-- 	"jmbuhr/otter.nvim",
		-- 	dependencies = {
		-- 		"nvim-treesitter/nvim-treesitter",
		-- 	},
		-- 	opts = {},
		-- },
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
