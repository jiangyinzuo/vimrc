local M = {}

local servers = { "pyrefly", "ty", "pyright", "basedpyright" }

local function switch(server)
	if not vim.tbl_contains(servers, server) then
		error("Python LSP must be one of: " .. table.concat(servers, ", "), 0)
	end
	local config = vim.lsp.config[server]
	if not config or not config.cmd then
		error("No LSP configuration found for " .. server, 0)
	end
	if type(config.cmd) == "table" and vim.fn.executable(config.cmd[1]) ~= 1 then
		error("Python LSP executable not found: " .. config.cmd[1], 0)
	end

	local path = vim.fn.expand("~/.vim/config.vim")
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_name(bufnr) == path and vim.bo[bufnr].modified then
			error("Save changes to " .. path .. " before switching Python LSP", 0)
		end
	end

	local lines = {}
	if vim.uv.fs_stat(path) then
		lines = vim.fn.readfile(path)
	end
	local assignment = "let g:python_lsp = '" .. server .. "'"
	-- 只替换末尾由本命令写出的赋值；不解析或改写用户的条件、注释和其它 Vimscript。
	-- 放在文件末尾，保证已有的默认值或赋值不会覆盖本次选择。
	if lines[#lines] and lines[#lines]:match("^let g:python_lsp = '[%w_]+'$") then
		lines[#lines] = assignment
	else
		lines[#lines + 1] = assignment
	end
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
	if vim.fn.writefile(lines, path) ~= 0 then
		error("Unable to save Python LSP to " .. path, 0)
	end
	-- 不 source 整份配置，避免重新执行用户配置里的其它副作用。
	vim.g.python_lsp = server
	for _, name in ipairs(servers) do
		if name ~= server then
			vim.lsp.enable(name, false)
		end
	end
	vim.lsp.enable(server)
	vim.cmd("checktime")
	vim.notify("Python LSP: " .. server .. " (saved to " .. path .. ")")
end

function M.setup()
	vim.api.nvim_create_user_command("PythonLspSwitch", function(opts)
		local function select(server)
			if not server then
				return
			end
			local ok, err = pcall(switch, server)
			if not ok then
				vim.notify(tostring(err), vim.log.levels.ERROR)
			end
		end
		if opts.args ~= "" then
			select(opts.args)
		else
			vim.ui.select(servers, {
				prompt = "Python LSP (current: " .. tostring(vim.g.python_lsp) .. "):",
			}, select)
		end
	end, {
		nargs = "?",
		complete = function(prefix)
			return vim.tbl_filter(function(server)
				return vim.startswith(server, prefix)
			end, servers)
		end,
		desc = "Switch Python LSP and persist the selection in ~/.vim/config.vim",
	})
end

return M
