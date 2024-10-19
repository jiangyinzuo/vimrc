local M = {}

local function setup_lsp(on_attach, capabilities)
	local lspconfig = require("lspconfig")
	if vim.fn.get(vim.g.nvim_lsp_autostart, "ccls", false) then
		lspconfig.ccls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			init_options = vim.g.ccls_init_options,
		})
	end
	if vim.fn.get(vim.g.nvim_lsp_autostart, "clangd", false) then
		lspconfig.clangd.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = vim.g.clangd_cmd,
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			root_dir = lspconfig.util.root_pattern(
				".project.vim",
				".git",
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt"
			),
		})
		-- use builtin inlay hints
		-- require("clangd_extensions.inlay_hints").setup_autocmd()
		-- require("clangd_extensions.inlay_hints").set_inlay_hints()
	end
	if vim.fn.get(vim.g.nvim_lsp_autostart, "lua_ls", false) then
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					codeLens = {
						enable = true,
					},
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					format = {
						enable = false,
						-- Put format options here
						-- NOTE: the value should be STRING!!
						defaultConfig = {
							indent_style = "tab",
							indent_size = "2",
						},
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
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
						callSnippet = "Replace",
					},
				},
			},
		})
	end
	if vim.fn.get(vim.g.nvim_lsp_autostart, "texlab", false) then
		lspconfig.texlab.setup({
			autostart = true,
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				texlab = {
					latexFormatter = "latexindent",
					latexindent = {
						["local"] = os.getenv("HOME") .. "/vimrc/root/latexindent.yaml", -- local is a reserved keyword
						modifyLineBreaks = false,
					},
					bibtexFormatter = "texlab",
					formatterLineLength = 80,
				},
			},
		})
	end

	if vim.fn.get(vim.g.nvim_lsp_autostart, "ltex", false) then
		-- ltex-ls.nvim似乎也不支持add to dictionary命令，建议使用coc.nvim
		lspconfig.ltex.setup({
			autostart = true,
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "bib", "tex", "latex" },
			settings = {
				ltex = {
					language = "en-US",
				},
			},
		})
	end

	if vim.fn.get(vim.g.nvim_lsp_autostart, "marksman", false) then
		-- marksman and markdown_oxide are both markdown language servers, choose one of them
		lspconfig.marksman.setup({
			autostart = true,
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end
	if vim.fn.get(vim.g.nvim_lsp_autostart, "markdown_oxide", false) then
		lspconfig.markdown_oxide.setup({
			autostart = true,
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern(".moxide.toml", ".git"),
		})
	end

	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
	-- npm i -g vscode-langservers-extracted
	-- "pylsp": too slow
	-- "pylyzer": report too many diagnostics
	local other_servers = { "jsonls", vim.g.python_lsp, "typst_lsp", "cmake", "html" }
	if vim.g.python_formatter == "ruff" then
		-- pip install ruff-lsp ruff
		table.insert(other_servers, "ruff_lsp")
	end
	for _, lsp in ipairs(other_servers) do
		lspconfig[lsp].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end

	vim.g.rustaceanvim = {
		-- Plugin configuration
		tools = {},
		-- LSP configuration
		server = {
			on_attach = on_attach,
			capabilities = capabilities,
		},
		-- DAP configuration
		dap = {},
	}

	-- sg is buggy
	-- require("sg").setup({
	-- 	-- Pass your own custom attach function
	-- 	--    If you do not pass your own attach function, then the following maps are provide:
	-- 	--        - gd -> goto definition
	-- 	--        - gr -> goto references
	-- 	on_attach = on_attach,
	-- 	capabilities = capabilities,
	-- })
end

M.attach_navic = function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		local navic = require("nvim-navic")
		navic.attach(client, bufnr)
	end
end

M.attach_inlay_hints = function(client, _)
	if vim.g.nvim_enable_inlayhints == 1 and client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true)
	end
end

local function attach_codelens(client, bufnr)
	-- 作者：贺呵呵
	-- 链接：https://www.zhihu.com/question/656229461/answer/3506519415
	-- 来源：知乎
	-- 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
	-- code lens
	if client.supports_method("textDocument/codeLens", { bufnr = bufnr }) then
		vim.lsp.codelens.refresh({ bufnr = bufnr })
		vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.refresh({ bufnr = bufnr })
			end,
		})
	end
end

-- Set up lspconfig.
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
-- capabilities = capabilities,
-- }
function M.get_capabilities()
	return require("cmp_nvim_lsp").default_capabilities()
end

function M.lspconfig()
	require("lsp.diagnostic")

	-- Register the command
	vim.api.nvim_create_user_command("InlayHintsToggle", function(_)
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, {})

	-- NOTE: 某个不知名的地方会重新设置diagnostic，故在此重新设置一遍
	vim.api.nvim_create_autocmd("CmdlineEnter", {
		once = true,
		callback = function()
			vim.diagnostic.config({
				-- virtual text is too noisy!
				virtual_text = false,
			})
		end,
	})
	vim.keymap.set("n", "<leader>da", vim.diagnostic.open_float)

	setup_lsp(function(client, bufnr)
		M.attach_navic(client, bufnr)
		M.attach_inlay_hints(client, bufnr)
		attach_codelens(client, bufnr)
	end, M.get_capabilities())

	-- remove default nvim lsp keymap
	if vim.version.ge(vim.version(), { 0, 10, 0 }) then
		vim.keymap.del("n", "]d")
		vim.keymap.del("n", "[d")
		vim.keymap.del("n", "]D")
		vim.keymap.del("n", "[D")
		vim.keymap.del({ "x", "n" }, "gra")
		vim.keymap.del("n", "gri")
		vim.keymap.del("n", "grn")
		vim.keymap.del("n", "grr")
	end
	-- Use LspAttach autocommand to only map the following keys
	-- after the language server attaches to the current buffer
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
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
			vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, bufopts)
			-- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
			-- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
			-- 	vim.keymap.set("n", "<space>wl", function()
			-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- 	end, bufopts)
			vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, bufopts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, bufopts)
			-- range_code_action and range_formatting are deprecated
			vim.keymap.set({ "n", "x" }, "<leader>ac", vim.lsp.buf.code_action, bufopts)
			vim.keymap.set({ "n", "x" }, "<leader>fmt", function()
				vim.lsp.buf.format({ async = true })
			end, bufopts)
			vim.diagnostic.config({
				-- virtual text is too noisy!
				virtual_text = false,
				-- ERROR 比 INFO优先级更高显示
				severity_sort = true,
			})
			vim.keymap.set("n", "]da", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, bufopts)
			vim.keymap.set("n", "[da", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, bufopts)
			vim.keymap.set("n", "]dw", function()
				vim.diagnostic.jump({ count = 1, severity = { min = vim.diagnostic.severity.WARN }, float = true })
			end, bufopts)
			vim.keymap.set("n", "[dw", function()
				vim.diagnostic.jump({ count = -1, severity = { min = vim.diagnostic.severity.WARN }, float = true })
			end, bufopts)
			vim.keymap.set("n", "]de", function()
				vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
			end, bufopts)
			vim.keymap.set("n", "[de", function()
				vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
			end, bufopts)
		end,
	})
	vim.api.nvim_create_user_command("OutgoingCalls", function(_)
		vim.lsp.buf.outgoing_calls()
	end, { nargs = 0 })
	vim.api.nvim_create_user_command("IncomingCalls", function(_)
		vim.lsp.buf.incoming_calls()
	end, { nargs = 0 })
	vim.api.nvim_create_user_command("LspLogClean", function(_)
		local log = vim.fn.stdpath("state") .. "/lsp.log"
		vim.fn.delete(log)
	end, { nargs = 0 })
end

return M
