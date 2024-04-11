local M = {}

local function nvim_navic()
	local navic = require("nvim-navic")
	navic.setup {
		icons = {
			File = ' ',
			Module = ' ',
			Namespace = ' ',
			Package = ' ',
			Class = ' ',
			Method = ' ',
			Property = ' ',
			Field = ' ',
			Constructor = ' ',
			Enum = ' ',
			Interface = ' ',
			Function = ' ',
			Variable = ' ',
			Constant = ' ',
			String = ' ',
			Number = ' ',
			Boolean = ' ',
			Array = ' ',
			Object = ' ',
			Key = ' ',
			Null = ' ',
			EnumMember = ' ',
			Struct = ' ',
			Event = ' ',
			Operator = ' ',
			TypeParameter = ' '
		},
		highlight = true,
		separator = " > ",
		depth_limit = 0,
		depth_limit_indicator = "..",
		safe_output = true
	}
	return navic
end

local function setup_lsp(on_attach, capabilities)
	local lspconfig = require('lspconfig')
	lspconfig.clangd.setup {
		on_attach = on_attach,
		capabilities = capabilities,
		cmd = vim.g.clangd_cmd,
	}
	require("clangd_extensions.inlay_hints").setup_autocmd()
	require("clangd_extensions.inlay_hints").set_inlay_hints()

	lspconfig.lua_ls.setup {
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
				},
				format = {
					enable = true,
					-- Put format options here
					-- NOTE: the value should be STRING!!
					defaultConfig = {
						indent_style = "tab",
						indent_size = "2",
					}
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { 'vim' },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
				completion = {
					callSnippet = "Replace"
				}
			},
		},
	}

	lspconfig.texlab.setup {
		autostart = vim.fn.get(vim.g.nvim_lsp_autostart, 'texlab', false),
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			texlab = {
				latexFormatter = 'latexindent',
				latexindent = {
					['local'] = os.getenv("HOME") .. '/vimrc/root/latexindent.yaml', -- local is a reserved keyword
					modifyLineBreaks = false,
				},
				bibtexFormatter = 'texlab',
				formatterLineLength = 80,
			},
		}
	}

	-- ltex-ls.nvim似乎也不支持add to dictionary命令，建议使用coc.nvim
	lspconfig.ltex.setup {
		autostart = vim.fn.get(vim.g.nvim_lsp_autostart, 'ltex', false),
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = { "bib", "tex", "latex" },
		settings = {
			ltex = {
				language = "en-US",
			},
		}
	}

	lspconfig.marksman.setup {
		autostart = vim.fn.get(vim.g.nvim_lsp_autostart, 'marksman', false),
		on_attach = on_attach,
		capabilities = capabilities,
	}

	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
	-- npm i -g vscode-langservers-extracted
	local other_servers = { 'jsonls', 'pyright', 'typst_lsp', 'marksman' }
	for _, lsp in ipairs(other_servers) do
		lspconfig[lsp].setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}
	end

	vim.g.rustaceanvim = {
		-- Plugin configuration
		tools = {
		},
		-- LSP configuration
		server = {
			on_attach = on_attach,
			capabilities = capabilities,
		},
		-- DAP configuration
		dap = {
		},
	}
end

function M.lspconfig()
	require('lsp.diagnostic')

	-- Register the command
	vim.api.nvim_create_user_command('InlayHintsToggle', function(_)
		vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
	end, {})
	local navic = nvim_navic()
	local on_attach = function(client, bufnr)
		if client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
		end
		if vim.g.nvim_enable_inlayhints == 1 and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(bufnr, true)
		end
	end

	-- NOTE: 某个不知名的地方会重新设置diagnostic，故在此重新设置一遍
	vim.api.nvim_create_autocmd("CmdlineEnter", {
		once = true,
		callback = function()
			vim.diagnostic.config({
				-- virtual text is too noisy!
				virtual_text = false,
			})
		end
	})
	vim.keymap.set('n', '<leader>da', vim.diagnostic.open_float)
	vim.keymap.set('n', '[da', vim.diagnostic.goto_prev)
	vim.keymap.set('n', ']da', vim.diagnostic.goto_next)

	-- Set up lspconfig.
	local capabilities = require('cmp_nvim_lsp').default_capabilities()
	-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
	-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
	-- capabilities = capabilities,
	-- }
	setup_lsp(on_attach, capabilities)

	-- Use LspAttach autocommand to only map the following keys
	-- after the language server attaches to the current buffer
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o>
			-- 让一些插件（如vimtex）自动设置omnifunc，lsp不要设置omnifunc
			-- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

			-- Mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local bufopts = { noremap = true, silent = true, buffer = ev.buf }
			vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
			vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, bufopts)
			vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, bufopts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
			-- 	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
			-- 	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
			-- 	vim.keymap.set("n", "<space>wl", function()
			-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- 	end, bufopts)
			vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, bufopts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set({ 'n', 'v' }, '<leader>ac', vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, bufopts)
			vim.keymap.set("n", "<leader>fmt", function()
				vim.lsp.buf.format { async = true }
			end, bufopts)
			vim.diagnostic.config({
				-- virtual text is too noisy!
				virtual_text = false,
				-- ERROR 比 INFO优先级更高显示
				severity_sort = true,
			})
		end,
	})
end

return M
