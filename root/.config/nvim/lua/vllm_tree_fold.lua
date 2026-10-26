-- Markdown 章节与围栏由 Tree-sitter 识别，仅细化 vllmclass 内的树线。
local M = {}
local cache = {}
local function ranges(buf)
	local tick = vim.api.nvim_buf_get_changedtick(buf)
	if cache[buf] and cache[buf].tick == tick then
		return cache[buf].lines
	end
	local lines = {}
	local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
	if not ok then
		return lines
	end
	local trees = parser:parse()
	local function walk(node)
		if node:type() == "fenced_code_block" then
			local info
			-- Markdown grammar 的 info_string 不一定是 named field。
			for child in node:iter_children() do
				if child:type() == "info_string" then
					info = child
				end
			end
			if info and vim.treesitter.get_node_text(info, buf):match("^%s*vllmclass%s*$") then
				local first, _, last = node:range()
				local current
				for row = first + 2, last do
					local text = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ""
					-- 只认树前缀，不把 Python 参数的空格缩进误当成调用深度。
					local prefix = text:match("^(.-)├─") or text:match("^(.-)└─")
					if prefix and prefix:gsub("│", ""):match("^%s*$") then
						current = math.floor(vim.fn.strdisplaywidth(prefix) / 2) + 1
						lines[row] = { first = first + 1, depth = current, start = true }
					elseif current and not text:match("^%s*[`~][`~][`~]") then
						lines[row] = { first = first + 1, depth = current }
					end
				end
			end
			return
		end
		for child in node:iter_children() do
			walk(child)
		end
	end
	if trees[1] then
		walk(trees[1]:root())
	end
	cache[buf] = { tick = tick, lines = lines }
	return lines
end

function M.expr(lnum)
	lnum = lnum or vim.v.lnum
	local entry = ranges(vim.api.nvim_get_current_buf())[lnum]
	if not entry then
		return vim.treesitter.foldexpr(lnum)
	end
	local base = tonumber(tostring(vim.treesitter.foldexpr(entry.first)):match("%d+")) or 0
	local level = base + entry.depth
	return entry.start and (">" .. level) or tostring(level)
end

function M.attach(buf)
	if not M.cleanup_registered then
		M.cleanup_registered = true
		vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
			callback = function()
				if vim.bo.filetype ~= "markdown" and vim.wo.foldexpr == "v:lua.require'vllm_tree_fold'.expr()" then
					vim.wo.foldexpr = "0"
				end
			end,
		})
	end
	vim.api.nvim_create_autocmd("BufWinLeave", {
		buffer = buf,
		callback = function()
			if vim.wo.foldexpr == "v:lua.require'vllm_tree_fold'.expr()" then
				vim.wo.foldexpr = "0"
				vim.wo.foldmethod = "manual"
				vim.wo.foldtext = "foldtext()"
			end
		end,
	})
	vim.api.nvim_create_autocmd("BufWinEnter", {
		buffer = buf,
		callback = function()
			if vim.bo.filetype == "markdown" then
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.require'vllm_tree_fold'.expr()"
				-- 空 foldtext 原样显示首行及其高亮，不重新着色或拼接行数。
				vim.wo.foldtext = ""
			end
		end,
	})
	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = buf,
		once = true,
		callback = function()
			cache[buf] = nil
		end,
	})
	-- after/ftplugin 的 Vimscript 仍会设置 MarkdownFold，等本轮 FileType 完成后覆盖。
	vim.schedule(function()
		for _, win in ipairs(vim.fn.win_findbuf(buf)) do
			if vim.bo[buf].filetype == "markdown" then
				vim.wo[win].foldmethod = "expr"
				vim.wo[win].foldexpr = "v:lua.require'vllm_tree_fold'.expr()"
				vim.wo[win].foldtext = ""
			end
		end
	end)
end

return M
