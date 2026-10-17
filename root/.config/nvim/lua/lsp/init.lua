local M = {}


local function setup_codeql_lsp()
	-- CodeQL's CLI includes an LSP server for QL query files.
	vim.filetype.add({
		extension = {
			ql = "ql",
		},
	})

	-- Set `g:codeql_cmd` to override the executable; otherwise resolve it from PATH.
	local codeql_cmd = vim.g.codeql_cmd or vim.fn.exepath("codeql")
	if codeql_cmd == "" then
		return false
	end

	local codeql_root = vim.fn.fnamemodify(codeql_cmd, ":p:h")
	local search_paths = {
		vim.fn.stdpath("data") .. "/codeql/packages",
		vim.fn.expand("~/.codeql/packages"),
		codeql_root .. "/qlpacks",
	}
	vim.lsp.config("codeql", {
		cmd = {
			codeql_cmd,
			"execute",
			"language-server",
			"--check-errors",
			"ON_CHANGE",
			"--search-path",
			table.concat(search_paths, vim.fn.has("win32") == 1 and ";" or ":"),
		},
		filetypes = { "ql" },
		root_markers = { "qlpack.yml", "codeql-pack.yml", ".git" },
	})
	return true
end

local function setup_lsp(capabilities)
	vim.lsp.config("*", {
		capabilities = capabilities,
	})

	local enabled_servers = {
		"clangd",
		"jsonls",
		vim.g.python_lsp,
		"neocmake",
		"html",
		"texlab",
		"leanls",
		"ts_ls",
		"astro",
		"gopls",
		"markdown_oxide",
		"tinymist",
	}
	if require("config").load_plugin.java then
		table.insert(enabled_servers, "jdtls")
	end
	vim.lsp.enable(enabled_servers)
end


M.attach_navic = function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		local navic = require("nvim-navic")
		navic.attach(client, bufnr)
	end
end

function M.get_capabilities()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	capabilities.completion = capabilities.completion or {}
	capabilities.completion.completionItem = capabilities.completion.completionItem or {}
	capabilities.completion.completionItem.preselectSupported = false
	return capabilities
end

local preferred_formatters = {
	astro = "astro",
	c = "clangd",
	cpp = "clangd",
	html = "html",
	javascript = "ts_ls",
	javascriptreact = "ts_ls",
	typescript = "ts_ls",
	typescriptreact = "ts_ls",
	tex = "texlab",
	plaintex = "texlab",
	typst = "tinymist",
}

local function configure_client_features(client, bufnr)
	if client:supports_method("textDocument/codeLens") then
		vim.lsp.codelens.enable(true, { bufnr = bufnr, client_id = client.id })
	end
	if client:supports_method("textDocument/inlineCompletion") then
		vim.lsp.inline_completion.enable(true, { bufnr = bufnr, client_id = client.id })
	end
	if client:supports_method("textDocument/documentColor") then
		vim.lsp.document_color.enable(true, { bufnr = bufnr, client_id = client.id })
	end
	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr, client_id = client.id })
	end

	local preferred = preferred_formatters[vim.bo[bufnr].filetype]
	if preferred and client:supports_method("textDocument/formatting") and client.name ~= preferred then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
end
function M.lspconfig()

	local diagnostic = require("lsp.diagnostic")

	-- NOTE: 某个不知名的地方会重新设置diagnostic，故在此重新设置一遍
	vim.api.nvim_create_autocmd("CmdlineEnter", {
		once = true,
		callback = diagnostic.setup_vim_diagnostic,
	})

	setup_lsp(M.get_capabilities())

	-- remove default nvim lsp keymap
	vim.keymap.del("n", "]d")
	vim.keymap.del("n", "[d")
	vim.keymap.del("n", "]D")
	vim.keymap.del("n", "[D")
	vim.keymap.del({ "x", "n" }, "gra")
	vim.keymap.del("n", "gri")
	vim.keymap.del("n", "grn")
	vim.keymap.del("n", "grr")
	vim.keymap.del("n", "grt")
	vim.keymap.del("n", "grx")
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
			local function jump_to_tab_on_list(opts)
				local items = opts.items or {}
				if #items == 0 then
					vim.notify("No item found", vim.log.levels.INFO)
					return
				end

				if #items == 1 then
					-- 单一结果：新开 tab 并跳转
					local it = items[1]
					local fname = it.filename or vim.api.nvim_buf_get_name(it.bufnr)
					vim.cmd("tabnew " .. vim.fn.fnameescape(fname))
					-- 跳到精确位置（lnum/col 从 1 开始；win col 从 0 开始）
					local lnum = it.lnum or 1
					local col = (it.col or 1) - 1
					vim.api.nvim_win_set_cursor(0, { lnum, col })
					-- 打开折叠并稍微居中一下
					vim.cmd("normal! zvzz")
				else
					-- 多个结果：塞进 quickfix 并打开
					vim.fn.setqflist({}, " ", { title = opts.title, items = items })
					vim.cmd("copen")
				end
			end
			vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "<C-w><leader>gD", function()
				vim.lsp.buf.declaration({ on_list = jump_to_tab_on_list })
			end, bufopts)
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
			vim.keymap.set("n", "<C-w><leader>gd", function()
				vim.lsp.buf.definition({ on_list = jump_to_tab_on_list })
			end, bufopts)
			-- neovim默认映射: K
			-- vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, bufopts)
			vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, bufopts)
			vim.keymap.set("n", "<C-w><leader>gi", function()
				vim.lsp.buf.implementation({ on_list = jump_to_tab_on_list })
			end, bufopts)
			-- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
			vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, bufopts)
			-- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
			-- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
			-- 	vim.keymap.set("n", "<space>wl", function()
			-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- 	end, bufopts)
			vim.keymap.set(
				"n",
				"<leader>gt",
				vim.lsp.buf.type_definition,
				{ noremap = true, silent = true, buffer = ev.buf, desc = "vim.lsp.buf.type_definition" }
			)
			vim.keymap.set("n", "<C-w><leader>gt", function()
				vim.lsp.buf.type_definition({ on_list = jump_to_tab_on_list })
			end, { noremap = true, silent = true, buffer = ev.buf, desc = "vim.lsp.buf.type_definition" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set(
				"n",
				"<leader>gr",
				vim.lsp.buf.references,
				{ noremap = true, silent = true, buffer = ev.buf, desc = "vim.lsp.buf.references" }
			)
			vim.keymap.set("n", "<C-w><leader>gr", function()
				vim.lsp.buf.references(nil, { on_list = jump_to_tab_on_list })
			end, { noremap = true, silent = true, buffer = ev.buf, desc = "vim.lsp.buf.references" })
			-- range_code_action and range_formatting are deprecated
			vim.keymap.set(
				{ "n", "x" },
				"<leader>ac",
				vim.lsp.buf.code_action,
				{ noremap = true, silent = true, buffer = ev.buf, desc = "vim.lsp.buf.code_action" }
			)
			diagnostic.setup_vim_diagnostic_on_attach(ev.buf)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			configure_client_features(client, ev.buf)
			M.attach_navic(client, ev.buf)
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
	vim.api.nvim_create_user_command("LspCodelensRun", function(_)
		vim.lsp.codelens.run()
	end, {})
end

return M
