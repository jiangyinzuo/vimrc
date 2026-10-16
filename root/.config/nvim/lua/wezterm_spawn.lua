local M = {}

-- Keep only explicitly spawned tasks alive. A clean wrapper exit lets the
-- default CloseOnCleanExit behavior close the tab after confirmation.
local hold = [[
trap ':' INT
"$@"
status=$?
printf '\n[Process exited with code %s. Press Enter to close.]\n' "$status"
IFS= read -r answer </dev/tty
exit 0
]]

function M.setup(wezterm)
	vim.api.nvim_create_user_command("WeztermSpawn", function(command)
		local program = command.fargs[1] or vim.env.SHELL or "/bin/sh"
		local args = { "-c", hold, "wezterm-spawn", program }
		vim.list_extend(args, vim.list_slice(command.fargs, 2))
		-- The existing WSL routing sends this sh and its argv through wsl.exe.
		wezterm.spawn("sh", { args = args })
	end, {
		nargs = "*",
		complete = "shellcmd",
		desc = "Spawn a WezTerm task and keep its output until Enter",
	})
end

return M
