local M = {}

local function visual_range()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")
	if start_line == 0 or end_line == 0 then
		return nil
	end
	return math.min(start_line, end_line), math.max(start_line, end_line)
end

function M.run(args)
	local start_line, end_line = visual_range()
	local buffer = vim.api.nvim_get_current_buf()
	local replace_start = start_line and start_line - 1 or vim.api.nvim_win_get_cursor(0)[1]
	local replace_end = start_line and end_line or replace_start
	local prompt = args.args

	local function start(prompt_text)
		if not prompt_text or prompt_text == "" then
			return
		end
		local command = { "pi", "--mode", "json", "-p" }
		if start_line then
			local name = vim.api.nvim_buf_get_name(buffer)
			local relative = vim.fn.fnamemodify(name, ":.")
			table.insert(command, "@" .. relative)
			prompt_text = (":L%d-L%d\n%s"):format(start_line, end_line, prompt_text)
		end
		table.insert(command, prompt_text)

		local pending, output, output_line_count = "", "", 0
		local progress = require("fidget.progress")
		local task = progress.handle.create({ title = "Pi", message = "Starting" })
		local finished = false
		local function finish(message, ok)
			if finished then
				return
			end
			finished = true
			task:finish({ message = message, success = ok })
		end
		local function append(text)
			output = output .. text
			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(buffer) then
					return
				end
				local lines = vim.split(output, "\n", { plain = true })
				vim.api.nvim_buf_set_lines(buffer, replace_start, replace_start + output_line_count, false, lines)
				output_line_count = #lines
			end)
		end

		vim.system(command, {
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
					if ok and event.type == "agent_start" then
						task:report({ message = "Working" })
					elseif ok and event.type == "tool_execution_start" then
						task:report({ message = "Running " .. (event.toolName or "tool") })
					elseif ok and event.type == "tool_execution_end" then
						task:report({ message = "Generating response" })
					elseif ok and event.type == "message_start" then
						task:report({ message = "Generating response" })
					elseif ok and event.type == "agent_end" then
						finish("Done", true)
					end
					local update = ok and event.type == "message_update" and event.assistantMessageEvent
					if update and update.type == "text_delta" then
						task:report({ message = "Streaming response" })
						append(update.delta or "")
					end
				end
			end,
		}, function(result)
			if result.code ~= 0 then
				finish("Failed", false)
				vim.schedule(function()
					vim.notify("pi failed: " .. result.stderr, vim.log.levels.ERROR)
				end)
			elseif not finished then
				finish("Done", true)
			end
		end)
	end

	if prompt == "" then
		vim.ui.input({ prompt = "Pi prompt: " }, start)
	else
		start(prompt)
	end
end

function M.setup()
	vim.api.nvim_create_user_command("PiStream", function(opts)
		M.run(opts)
	end, {
		desc = "Stream Pi JSON output into the current buffer or visual selection",
		nargs = "*",
		range = true,
	})
end

return M
