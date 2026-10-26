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
						lines[row] = { first = first + 1, depth = current, start = true, node = true }
					elseif current and not text:match("^%s*[`~][`~][`~]") then
						lines[row] = { first = first + 1, depth = current + 1 }
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
	local nodes = {}
	for row, entry in pairs(lines) do
		if entry.start then
			nodes[#nodes + 1] = { row = row, entry = entry }
		end
	end
	table.sort(nodes, function(left, right)
		return left.row < right.row
	end)
	for index, node in ipairs(nodes) do
		local next_node = nodes[index + 1]
		local continuation = lines[node.row + 1]
		local has_continuation = continuation and not continuation.node
		lines[node.row].start = (next_node and next_node.entry.depth > node.entry.depth) or has_continuation or false
	end
	cache[buf] = { tick = tick, lines = lines }
	return lines
end

local function configure_window(win, buf)
	local window = vim.wo[win]
	window.foldexpr = "v:lua.require'vllmclass.fold'.expr()"
	window.foldtext = ""
	window.foldmethod = "expr"
end

local focus = {}

local function reset_folds(win)
	local window = vim.wo[win]
	local method = window.foldmethod
	window.foldmethod = "manual"
	window.foldmethod = method
	vim.api.nvim_win_call(win, function()
		vim.cmd("normal! zX")
	end)
end

function M.toggle()
	local buf, win = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
	local row = vim.api.nvim_win_get_cursor(win)[1]
	local entry = ranges(buf)[row]
	if entry and entry.node then
		if not entry.start then
			return
		end
	elseif not entry then
		return vim.cmd("normal! za")
	end
	local was_closed = vim.fn.foldclosed(row) == row
	if focus[buf] == row then
		focus[buf] = nil
	else
		focus[buf] = row
	end
	reset_folds(win)
	vim.cmd(was_closed and "normal! zO" or "normal! za")
end

function M.expr(lnum)
	lnum = lnum or vim.v.lnum
	local buf = vim.api.nvim_get_current_buf()
	local lines = ranges(buf)
	local entry = lines[lnum]
	local selected = focus[buf]
	local target = selected and lines[selected]
	if target and entry and entry.first == target.first and lnum >= selected then
		local base = tonumber(tostring(vim.treesitter.foldexpr(entry.first)):match("%d+")) or 0
		if lnum == selected then
			return ">" .. (base + 1)
		elseif entry.depth > target.depth then
			return tostring(base + math.min(entry.depth - target.depth + 1, 19))
		else
			return tostring(base)
		end
	end
	if not entry then
		return vim.treesitter.foldexpr(lnum)
	end
	local base = tonumber(tostring(vim.treesitter.foldexpr(entry.first)):match("%d+")) or 0
	local level = base + math.min(entry.depth, 19)
	return entry.start and (">" .. level) or tostring(level)
end

function M.attach(buf)
	if not M.cleanup_registered then
		M.cleanup_registered = true
		vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
			callback = function()
				if vim.bo.filetype ~= "markdown" and vim.wo.foldexpr == "v:lua.require'vllmclass.fold'.expr()" then
					vim.wo.foldexpr = "0"
				end
			end,
		})
	end
	vim.keymap.set("n", "za", M.toggle, { buffer = buf, desc = "Toggle vLLM call-tree fold" })
	vim.api.nvim_create_autocmd("BufWinLeave", {
		buffer = buf,
		callback = function()
			if vim.wo.foldexpr == "v:lua.require'vllmclass.fold'.expr()" then
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
				-- 空 foldtext 原样显示首行及其高亮，不重新着色或拼接行数。
				configure_window(vim.api.nvim_get_current_win(), buf)
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
				configure_window(win, buf)
			end
		end
	end)
end

return M
