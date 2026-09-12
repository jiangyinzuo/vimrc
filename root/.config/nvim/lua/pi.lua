local M = {}
local active_process
local active_finish

local function inline_edit_range()
	local inline_edit_start, inline_edit_end = vim.fn.line("'<"), vim.fn.line("'>")
	if inline_edit_start == 0 or inline_edit_end == 0 then
		return nil
	end
	return math.min(inline_edit_start, inline_edit_end), math.max(inline_edit_start, inline_edit_end)
end

local function build_command(prompt, buffer, inline_edit_start, inline_edit_end, no_tools)
	local command = { "pi", "--mode", "json" }
	if no_tools then
		table.insert(command, "--no-tools")
	end
	table.insert(command, "-p")
	table.insert(command, "--")
	if inline_edit_start then
		local path = vim.api.nvim_buf_get_name(buffer)
		if path == "" then
			vim.notify("Pi inline edit requires a named file", vim.log.levels.ERROR)
			return nil
		end
		table.insert(command, "@" .. path)
		prompt = ([=[根据用户的要求，对以下文本做替换，不要生成额外内容。

下面是文本
@%s :L%d-L%d

下面是用户要求
%s]=]):format(path, inline_edit_start, inline_edit_end, prompt)
	end
	table.insert(command, prompt)
	return command
end

local function make_output_writer(buffer, start_row, replaced_line_count)
	local output, line_count = "", replaced_line_count
	return function(text)
		output = output .. text
		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(buffer) then
				return
			end
			local lines = vim.split(output, "\n", { plain = true })
			vim.api.nvim_buf_set_lines(buffer, start_row, start_row + line_count, false, lines)
			line_count = #lines
		end)
	end
end

local function make_progress()
	local task = require("fidget.progress").handle.create({ title = "Pi", message = "Starting" })
	local notify = require("fidget").notify
	local finished = false
	return task,
		notify,
		function(message, success)
			if finished then
				return
			end
			finished = true
			task:finish({ message = message, success = success })
		end,
		function()
			return finished
		end
end

local function handle_event(event, task, notify, finish, append)
	if event.type == "agent_start" then
		task:report({ message = "Working" })
	elseif event.type == "tool_execution_start" then
		local tool = event.toolName or "tool"
		task:report({ message = "Running " .. tool })
		notify("Pi: Running " .. tool)
	elseif event.type == "tool_execution_end" or event.type == "message_start" then
		task:report({ message = "Generating response" })
	elseif event.type == "agent_end" then
		finish("Done", true)
		notify("Pi: Done")
	elseif event.type == "message_update" and event.assistantMessageEvent then
		local update = event.assistantMessageEvent
		if update.type == "text_delta" then
			task:report({ message = "Streaming response" })
			append(update.delta or "")
		end
	end
end

local function start_process(command, buffer, start_row, replaced_line_count)
	local pending = ""
	local task, notify, finish, is_finished = make_progress()
	active_finish = finish
	local append = make_output_writer(buffer, start_row, replaced_line_count)
	active_process = vim.system(command, {
		text = true,
		stdout = function(_, data)
			pending = pending .. (data or "")
			while true do
				local line_end = pending:find("\n", 1, true)
				if not line_end then
					break
				end
				local line = pending:sub(1, line_end - 1)
				pending = pending:sub(line_end + 1)
				local ok, event = pcall(vim.json.decode, line)
				if ok then
					handle_event(event, task, notify, finish, append)
				end
			end
		end,
	}, function(result)
		active_process = nil
		active_finish = nil
		if result.code ~= 0 then
			finish("Failed", false)
			notify("Pi: Failed")
			vim.schedule(function()
				vim.notify("pi failed: " .. result.stderr, vim.log.levels.ERROR)
			end)
		elseif not is_finished() then
			finish("Done", true)
		end
	end)
end

function M.stop()
	if not active_process then
		vim.notify("No Pi process is running", vim.log.levels.INFO)
		return
	end
	if active_finish then
		active_finish("Cancelled", false)
	end
	active_process:kill(15)
	active_process = nil
	active_finish = nil
	vim.notify("Pi cancelled", vim.log.levels.INFO)
end

function M.git_commit_message(args)
	local buffer = vim.api.nvim_get_current_buf()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local is_amend = (vim.env.GIT_REFLOG_ACTION or ""):find("amend", 1, true) ~= nil
	local diff_command = { "git", "diff", "--no-ext-diff", "--no-color" }
	if is_amend then
		vim.list_extend(diff_command, { "HEAD^", "--cached" })
	else
		table.insert(diff_command, "--cached")
	end
	vim.system(diff_command, { text = true }, function(result)
		if result.code ~= 0 then
			vim.schedule(function()
				vim.notify("git diff failed: " .. result.stderr, vim.log.levels.ERROR)
			end)
			return
		end
		if result.stdout == "" then
			vim.schedule(function()
				vim.notify("git diff is empty", vim.log.levels.WARN)
			end)
			return
		end
		local extra_instruction = args.args ~= "" and "\n\n补充要求：\n" .. args.args or ""
		local prompt = ([=[根据下面的 git diff 生成 Git commit message。

要求：
1. 只输出 commit message，不要输出解释、Markdown 标记、代码块或引号。
2. 第一行使用 Conventional Commits 格式：type(scope): summary。
3. summary 使用英文祈使句，简洁准确，不超过 72 个字符。
4. 如果改动涉及多个主题，只保留最主要的主题作为第一行。


下面是 git diff：
%s%s]=]):format(result.stdout, extra_instruction)
		vim.schedule(function()
			start_process({ "pi", "--mode", "json", "--no-tools", "-p", "--", prompt }, buffer, row, 0)
		end)
	end)
end

function M.run(args, no_tools)
	local inline_edit_start, inline_edit_end = inline_edit_range()
	local buffer = vim.api.nvim_get_current_buf()
	local inline_edit_row = inline_edit_start and inline_edit_start - 1 or vim.api.nvim_win_get_cursor(0)[1]
	local inline_edit_line_count = inline_edit_start and inline_edit_end - inline_edit_start + 1 or 0
	local prompt = args.args
	local function start(text)
		if text and text ~= "" then
			local command = build_command(text, buffer, inline_edit_start, inline_edit_end, no_tools)
			if command then
				start_process(command, buffer, inline_edit_row, inline_edit_line_count)
			end
		end
	end
	if prompt == "" then
		vim.ui.input({ prompt = "Pi prompt: " }, start)
	else
		start(prompt)
	end
end

function M.setup()
	vim.api.nvim_create_user_command("Pi", function(opts)
		M.run(opts)
	end, {
		desc = "Stream Pi JSON output into the current buffer or visual selection",
		nargs = "*",
		range = true,
	})
	vim.api.nvim_create_user_command("PiNoTools", function(opts)
		M.run(opts, true)
	end, {
		desc = "Stream Pi output without tools",
		nargs = "*",
		range = true,
	})
	vim.api.nvim_create_user_command("PiStop", M.stop, {
		desc = "Cancel the running Pi process",
	})
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "gitcommit",
		callback = function(event)
			vim.api.nvim_buf_create_user_command(event.buf, "PiNoToolsGitCommitMessage", function(opts)
				M.git_commit_message(opts)
			end, {
				desc = "Generate a commit message from git diff without tools",
				nargs = "*",
			})
		end,
	})
end

return M
