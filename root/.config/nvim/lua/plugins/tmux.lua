local cond = vim.fn.executable("tmux") ~= 0
local function send_to_tmux_pane()
	local tmux_send = require("tmux_send")

	local function tmux_eval(args)
		local out = vim.fn.systemlist(args)
		if vim.v.shell_error ~= 0 then
			return nil
		end
		return out
	end

	local function tmux_send_keys(uid, keys)
		if not uid or not keys or #keys == 0 then
			return false
		end

		local args = { "tmux", "send-keys", "-t", "%" .. tostring(uid) }
		vim.list_extend(args, keys)

		vim.fn.system(args)
		return vim.v.shell_error == 0
	end

	local function get_target_pane_command(uid)
		if not uid then
			return nil
		end

		local out = tmux_eval({
			"tmux",
			"display-message",
			"-p",
			"-t",
			"%" .. tostring(uid),
			"#{pane_current_command}",
		})

		if not out or not out[1] or out[1] == "" then
			return nil
		end

		return out[1]
	end

	local function get_path_from_special_buffer()
		local ft = vim.bo.filetype

		if ft == "neo-tree" then
			local ok, manager = pcall(require, "neo-tree.sources.manager")
			if not ok then
				vim.notify("neo-tree manager not found", vim.log.levels.ERROR)
				return nil
			end

			local state = manager.get_state("filesystem")
			if not state or not state.tree then
				vim.notify("neo-tree state not found", vim.log.levels.WARN)
				return nil
			end

			local node = state.tree:get_node()
			if not node then
				vim.notify("neo-tree node not found", vim.log.levels.WARN)
				return nil
			end

			return vim.fn.fnamemodify(node:get_id(), ":p")
		end

		if ft == "oil" then
			local ok, oil = pcall(require, "oil")
			if not ok then
				vim.notify("oil not found", vim.log.levels.ERROR)
				return nil
			end

			local entry = oil.get_cursor_entry()
			local dir = oil.get_current_dir()
			if not dir then
				vim.notify("oil current dir not found", vim.log.levels.WARN)
				return nil
			end

			if not entry then
				return vim.fn.fnamemodify(dir, ":p")
			end

			local path
			if vim.fs and vim.fs.joinpath then
				path = vim.fs.joinpath(dir, entry.name)
			else
				path = dir .. entry.name
			end

			return vim.fn.fnamemodify(path, ":p")
		end

		return nil
	end

	local function is_shell_command(cmd)
		return cmd == "bash" or cmd == "zsh" or cmd == "fish" or cmd == "sh"
	end

	local function is_nvim_command(cmd)
		return cmd == "nvim" or cmd == "vim"
	end

	local function send_command_to_nvim(uid, path, cmd)
		local escaped = vim.fn.fnameescape(path)
		return tmux_send_keys(uid, {
			"Escape",
			":" .. cmd .. " " .. escaped,
			"Enter",
		})
	end

	local function dispatch_path(path, uid, pane_cmd)
		local is_dir = vim.fn.isdirectory(path) == 1

		if is_dir then
			if is_shell_command(pane_cmd) then
				tmux_send.send_to_pane({
					count_is_uid = true,
					content = "cd -- " .. vim.fn.shellescape(path) .. "\r",
				})
				return
			end

			if is_nvim_command(pane_cmd) then
				send_command_to_nvim(uid, path, "cd")
				return
			end

			tmux_send.send_to_pane({
				count_is_uid = true,
				content = path,
			})
			return
		end

		if is_shell_command(pane_cmd) then
			tmux_send.send_to_pane({
				count_is_uid = true,
				content = "nvim " .. vim.fn.shellescape(path) .. "\r",
			})
			return
		end

		if is_nvim_command(pane_cmd) then
			send_command_to_nvim(uid, path, "e")
			return
		end

		tmux_send.send_to_pane({
			count_is_uid = true,
			content = path,
		})
	end

	local ft = vim.bo.filetype
	if ft == "neo-tree" or ft == "oil" then
		local path = get_path_from_special_buffer()
		if not path or path == "" then
			return
		end

		local uid = vim.v.count
		if not uid then
			vim.notify("No target tmux pane uid. Use [count]`` first, e.g. 3``", vim.log.levels.WARN)
			return
		end

		local pane_cmd = get_target_pane_command(uid)
		dispatch_path(path, uid, pane_cmd)
		return
	end

	tmux_send.send_to_pane({
		count_is_uid = true,
		content = nil,
	})

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
end

local function send_prompt_to_tmux_pane(input)
	require("tmux_send").send_to_pane({ count_is_uid = true, content = require("sidekick.cli").render(input) })
	-- (Optional) exit visual mode after sending
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
end
return {
	{
		"kiyoon/tmux-send.nvim",
		cond = cond,
		keys = {
			{
				"``",
				function()
					send_to_tmux_pane()

					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
				end,
				mode = { "n", "x" },
				desc = "Send to tmux pane",
			},
			{
				"`1",
				function()
					send_prompt_to_tmux_pane("{this}")
				end,
				mode = { "n", "x" },
				desc = "Send file to tmux pane",
			},
		},
	},
	{
		"preservim/vimux",
		cond = cond,
	},
}
