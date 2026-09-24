local M = {}

local state = {
	buf = nil,
	win = nil,
	run = 0,
	items = {},
	pair = nil,
}

local output_root = "/tmp/jscpd.nvim"
local highlight_namespace = vim.api.nvim_create_namespace("jscpd-report")
local flash_namespace = vim.api.nvim_create_namespace("jscpd-match-flash")
local jscpd_augroup = vim.api.nvim_create_augroup("jscpd-report", { clear = true })

vim.api.nvim_set_hl(0, "JscpdTitle", { link = "Title", default = true })
vim.api.nvim_set_hl(0, "JscpdHint", { link = "SpecialComment", default = true })
vim.api.nvim_set_hl(0, "JscpdSummary", { link = "String", default = true })
vim.api.nvim_set_hl(0, "JscpdCommand", { link = "Comment", default = true })
vim.api.nvim_set_hl(0, "JscpdMeta", { link = "Comment", default = true })
vim.api.nvim_set_hl(0, "JscpdDuplicate", { link = "DiagnosticInfo", default = true })
vim.api.nvim_set_hl(0, "JscpdFile", { link = "Directory", default = true })
vim.api.nvim_set_hl(0, "JscpdSuccess", { link = "DiagnosticOk", default = true })
vim.api.nvim_set_hl(0, "JscpdProgress", { link = "Todo", default = true })
vim.api.nvim_set_hl(0, "JscpdError", { link = "DiagnosticError", default = true })

vim.api.nvim_create_autocmd("FileType", {
	group = jscpd_augroup,
	pattern = "jscpd",
	callback = function(args)
		vim.keymap.set("n", "<CR>", function()
			M.open_pair()
		end, {
			buffer = args.buf,
			silent = true,
			desc = "Open jscpd duplicate pair",
		})
	end,
})

local function is_valid_buffer(buf)
	return buf and vim.api.nvim_buf_is_valid(buf)
end

local function is_valid_window(win)
	return win and vim.api.nvim_win_is_valid(win)
end

local function split_command_line(command_line)
	local args = {}
	local current = {}
	local quoted = nil
	local escaped = false
	local started = false

	for i = 1, #command_line do
		local char = command_line:sub(i, i)
		if escaped then
			table.insert(current, char)
			escaped = false
			started = true
		elseif char == "\\" and quoted ~= "'" then
			escaped = true
			started = true
		elseif quoted then
			if char == quoted then
				quoted = nil
			else
				table.insert(current, char)
			end
			started = true
		elseif char == "'" or char == '"' then
			quoted = char
			started = true
		elseif char:match("%s") then
			if started then
				table.insert(args, table.concat(current))
				current = {}
				started = false
			end
		else
			table.insert(current, char)
			started = true
		end
	end

	if escaped then
		table.insert(current, "\\")
	end
	if quoted then
		return nil, "未闭合的引号"
	end
	if started then
		table.insert(args, table.concat(current))
	end
	return args
end

-- These options describe the report that this module consumes.  Remove user
-- values before appending our own values, while preserving all scan options.
local function remove_report_options(args)
	local result = {}
	local skip_next = false
	for _, arg in ipairs(args) do
		if skip_next then
			skip_next = false
		elseif arg == "-r" or arg == "--reporters" or arg == "-o" or arg == "--output" then
			skip_next = true
		elseif arg:match("^%-r.+") or arg:match("^%-%-reporters=") or arg:match("^%-o.+") or arg:match("^%-%-output=") then
			-- The value is attached to the option.
		else
			table.insert(result, arg)
		end
	end
	return result
end

local function setup_buffer(buf)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = true
	vim.bo[buf].filetype = "jscpd"

	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = buf,
		once = true,
		callback = function()
			if state.buf == buf then
				state.buf = nil
				state.win = nil
				state.items = {}
				state.pair = nil
			end
		end,
	})
end

local function result_window()
	if is_valid_window(state.win) and is_valid_buffer(state.buf) then
		return state.win, state.buf
	end

	vim.cmd("botright split")
	-- A split created from one side of a vertical pair would otherwise stay
	-- in that side. Move the report window to the bottom so it spans the tab.
	vim.cmd("wincmd J")
	local win = vim.api.nvim_get_current_win()
	local buf = state.buf
	if not is_valid_buffer(buf) then
		buf = vim.api.nvim_create_buf(false, true)
		state.buf = buf
		setup_buffer(buf)
	end
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_win_set_height(win, math.max(1, math.min(12, vim.o.lines - 5)))
	state.win = win
	return win, buf
end

local function set_result_lines(lines, items)
	local win, buf = result_window()
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.api.nvim_buf_clear_namespace(buf, highlight_namespace, 0, -1)
	for row, line in ipairs(lines) do
		local group
		if row == 1 then
			group = "JscpdTitle"
		elseif line:match("^Keys:") then
			group = "JscpdHint"
		elseif line:match("^Summary:") then
			group = "JscpdSummary"
		elseif line:match("^Command:") then
			group = "JscpdCommand"
		elseif line:match("^Working directory:") then
			group = "JscpdMeta"
		elseif line:match("^%[%d+%]") then
			group = "JscpdDuplicate"
		elseif line:match("^%s+[AB]:") then
			group = "JscpdFile"
		elseif line:match("^No duplicates found%.") then
			group = "JscpdSuccess"
		elseif line:match("^Running jscpd") then
			group = "JscpdProgress"
		elseif line:match("^jscpd failed") then
			group = "JscpdError"
		end
		if group and line ~= "" then
			vim.api.nvim_buf_set_extmark(buf, highlight_namespace, row - 1, 0, {
				end_row = row,
				hl_group = group,
			})
		end
	end
	state.items = items
	vim.api.nvim_set_current_win(win)
	vim.api.nvim_win_set_cursor(win, { 1, 0 })
end

local function number(value, fallback)
	return tonumber(value) or fallback
end

local function file_text(file)
	if not file then
		return "?"
	end
	return string.format("%s:%d-%d", file.name or "?", number(file.start, 0), number(file["end"], 0))
end

local function report_lines(report, command, cwd)
	local statistics = report.statistics or {}
	local total = statistics.total or {}
	local duplicates = report.duplicates or {}
	local lines = {
		"jscpd duplicate report",
		"Keys: <Enter>  open the duplicate pair in two windows and center the matching lines",
		"Command: " .. command,
		string.format(
			"Summary: %d clone(s), %d duplicated line(s) / %d line(s) (%.2f%%), %d source file(s)",
			number(total.clones, #duplicates),
			number(total.duplicatedLines, 0),
			number(total.lines, 0),
			number(total.percentage, 0),
			number(total.sources, 0)
		),
		"Working directory: " .. cwd,
		"",
	}
	local items = {}

	if #duplicates == 0 then
		table.insert(lines, "No duplicates found.")
		return lines, items
	end

	for index, duplicate in ipairs(duplicates) do
		local first = duplicate.firstFile or {}
		local second = duplicate.secondFile or {}
		local item = {
			first = first,
			second = second,
			cwd = cwd,
		}
		local header = #lines + 1
		table.insert(
			lines,
			string.format(
				"[%d] %s %s clone (%d lines, %d tokens)%s",
				index,
				duplicate.kind or "unknown",
				duplicate.format and ("· " .. duplicate.format) or "",
				number(duplicate.lines, 0),
				number(duplicate.tokens, 0),
				duplicate.isNew and " · new" or ""
			)
		)
		table.insert(lines, "    A: " .. file_text(first))
		table.insert(lines, "    B: " .. file_text(second))
		table.insert(lines, "")
		for line = header, #lines do
			items[line] = item
		end
	end
	return lines, items
end

local function show_message(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "jscpd" })
end

local function display_error(message)
	set_result_lines({ "jscpd failed", "", message, "" }, {})
	show_message(message, vim.log.levels.ERROR)
end

local function path_for_file(cwd, name)
	if not name or name == "" then
		return nil
	end
	if name:sub(1, 1) == "/" then
		return name
	end
	return cwd .. "/" .. name
end

local function center_window_at(win, line)
	if not is_valid_window(win) then
		return
	end
	local buf = vim.api.nvim_win_get_buf(win)
	local max_line = math.max(1, vim.api.nvim_buf_line_count(buf))
	line = math.min(math.max(number(line, 1), 1), max_line)
	vim.api.nvim_win_set_cursor(win, { line, 0 })
	vim.api.nvim_win_call(win, function()
		vim.cmd("normal! zz")
	end)
	vim.hl.range(buf, flash_namespace, "MatchWord", { line - 1, 0 }, { line - 1, -1 }, { regtype = "V", timeout = 700 })
end

local function configure_pair_buffer(buf)
	vim.bo[buf].buftype = ""
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = true
	vim.bo[buf].readonly = false
end

local function finish_file_load(win, buf, path, line, err, text)
	vim.schedule(function()
		if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
			return
		end
		if vim.api.nvim_win_get_buf(win) ~= buf then
			return
		end
		if err then
			vim.bo[buf].modifiable = true
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
				"[Unable to read " .. path .. "]",
				err,
			})
			vim.bo[buf].modifiable = false
			return
		end
		local lines = vim.split(text or "", "\n", { plain = true })
		vim.bo[buf].modifiable = true
		vim.bo[buf].readonly = false
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.bo[buf].modified = false
		vim.bo[buf].readonly = true
		vim.bo[buf].modifiable = false
		vim.bo[buf].filetype = vim.filetype.match({ filename = path }) or ""
		center_window_at(win, line)
	end)
end

local function read_file_async(win, buf, path, line)
	vim.uv.fs_open(path, "r", 438, function(open_err, fd)
		if open_err then
			finish_file_load(win, buf, path, line, tostring(open_err))
			return
		end
		vim.uv.fs_fstat(fd, function(stat_err, stat)
			if stat_err then
				vim.uv.fs_close(fd)
				finish_file_load(win, buf, path, line, tostring(stat_err))
				return
			end
			vim.uv.fs_read(fd, tonumber(stat.size) or 0, 0, function(read_err, text)
				vim.uv.fs_close(fd)
				finish_file_load(win, buf, path, line, read_err and tostring(read_err) or nil, text)
			end)
		end)
	end)
end

local function load_file_async(win, path, line)
	local buf = vim.fn.bufnr(path)
	local was_loaded = buf ~= -1 and vim.api.nvim_buf_is_loaded(buf)
	if buf == -1 then
		buf = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_buf_set_name(buf, path)
	end
	if was_loaded then
		vim.api.nvim_win_set_buf(win, buf)
		center_window_at(win, line)
		return
	end
	configure_pair_buffer(buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "[Loading " .. path .. "...]" })
	vim.api.nvim_win_set_buf(win, buf)
	center_window_at(win, line)
	read_file_async(win, buf, path, line)
end

local function pair_windows(tab)
	local pair = state.pair
	if not pair or pair.tab ~= tab or not is_valid_window(pair.left) or not is_valid_window(pair.right) then
		state.pair = nil
		return nil
	end
	local windows = vim.api.nvim_tabpage_list_wins(tab)
	if not vim.tbl_contains(windows, pair.left) or not vim.tbl_contains(windows, pair.right) then
		state.pair = nil
		return nil
	end
	return pair
end

function M.open_pair()
	local current_buf = vim.api.nvim_get_current_buf()
	if current_buf ~= state.buf then
		show_message("请在 jscpd buffer 中使用 <Enter>", vim.log.levels.WARN)
		return
	end
	local item = state.items[vim.api.nvim_win_get_cursor(0)[1]]
	if not item then
		show_message("当前行没有对应的重复代码块", vim.log.levels.WARN)
		return
	end

	local current_tab = vim.api.nvim_get_current_tabpage()
	local first_path = path_for_file(item.cwd, item.first.name)
	local second_path = path_for_file(item.cwd, item.second.name)
	if not first_path or not second_path then
		show_message("报告中缺少重复文件路径", vim.log.levels.ERROR)
		return
	end

	local pair = pair_windows(current_tab)
	if not pair then
		local upper_win
		local result_row = vim.api.nvim_win_get_position(state.win)[1]
		local best_row = -1
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
			local row = vim.api.nvim_win_get_position(win)[1]
			if win ~= state.win and row < result_row and row > best_row then
				upper_win = win
				best_row = row
			end
		end
		if not upper_win then
			vim.api.nvim_set_current_win(state.win)
			vim.cmd("aboveleft split")
			upper_win = vim.api.nvim_get_current_win()
		end
		vim.api.nvim_set_current_win(upper_win)
		vim.cmd("vsplit")
		pair = {
			tab = current_tab,
			left = upper_win,
			right = vim.api.nvim_get_current_win(),
		}
		state.pair = pair
	end

	load_file_async(pair.left, first_path, item.first.start)
	load_file_async(pair.right, second_path, item.second.start)
	vim.api.nvim_set_current_win(state.win)
end

local function run(args_text)
	local args, parse_error = split_command_line(args_text)
	if not args then
		display_error(parse_error)
		return
	end
	args = remove_report_options(args)

	state.run = state.run + 1
	local run_id = state.run
	local run_dir = string.format("%s/%d-%d", output_root, os.time(), run_id)
	vim.fn.mkdir(run_dir, "p")
	local cwd = vim.fn.getcwd()
	local command = vim.g.jscpd_command or "jscpd"
	local command_args = { command }
	vim.list_extend(command_args, args)
	vim.list_extend(command_args, {
		"--reporters=json",
		"--output=" .. run_dir,
		"--absolute",
		"--no-colors",
		"--no-tips",
	})

	local command_display = table.concat(vim.tbl_map(vim.fn.shellescape, command_args), " ")
	set_result_lines({ "Running jscpd...", "", command_display, "" }, {})

	vim.system(command_args, { cwd = cwd, text = true }, function(result)
		vim.schedule(function()
			if run_id ~= state.run then
				return
			end
			local report_path = run_dir .. "/jscpd-report.json"
			local report_file = io.open(report_path, "r")
			if not report_file then
				local details = (result.stderr and result.stderr:gsub("%s+$", "")) or ""
				display_error(string.format("退出码 %d%s", result.code or -1, details ~= "" and (": " .. details) or ""))
				return
			end
			local json = report_file:read("*a")
			report_file:close()
			local ok, report = pcall(vim.json.decode, json)
			if not ok or type(report) ~= "table" then
				display_error("无法解析 JSON 报告: " .. report_path)
				return
			end
			local lines, items = report_lines(report, command_display, cwd)
			set_result_lines(lines, items)
			show_message(string.format("发现 %d 个重复代码块", #(report.duplicates or {})))
		end)
	end)
end

function M.toggle()
	if is_valid_window(state.win) and is_valid_buffer(state.buf) then
		vim.api.nvim_win_close(state.win, false)
		state.win = nil
		return
	end
	if not is_valid_buffer(state.buf) then
		show_message("还没有运行过 :Jscpd", vim.log.levels.INFO)
		return
	end
	result_window()
end

vim.api.nvim_create_user_command("Jscpd", function(opts)
	run(opts.args)
end, {
	nargs = "*",
	complete = "file",
	desc = "Run jscpd asynchronously and show its JSON report",
})

vim.api.nvim_create_user_command("JscpdToggle", function()
	M.toggle()
end, {
	desc = "Toggle the last jscpd report",
})

return M
