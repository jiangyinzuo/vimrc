-- Run from the vimrc root: nvim --headless -u NONE -i NONE -l terminal/tests/wezterm_spawn.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd() .. "/root/.config/nvim")
local specs = dofile("root/.config/nvim/lua/plugins/terminal.lua")
local spec
for _, candidate in ipairs(specs) do
	if candidate[1] == "jiangyinzuo/wezterm.nvim" then spec = candidate end
end
assert(spec)
local function equal(actual, expected)
	assert(vim.deep_equal(actual, expected), vim.inspect({ actual = actual, expected = expected }))
end

local has, executable = vim.fn.has, vim.fn.executable
local spawned_program, spawned_opts, local_command
for _, wsl in ipairs({ 1, 0 }) do
	vim.fn.has = function(feature)
		if feature == "wsl" then return wsl end
		return has(feature)
	end
	vim.fn.executable = function(name)
		if name == "wezterm" then return wsl == 1 and 0 or 1 end
		return executable(name)
	end
	package.loaded.wezterm = {
		setup = function() return true end,
		spawn = function(program, opts)
			spawned_program, spawned_opts = program, opts
		end,
	}
	spec.config()
	vim.cmd([[WeztermSpawn printf %s hello\ world\ $HOME\ $(false)]])
	local args = spawned_opts.args
	if wsl == 1 then
		equal(spawned_program, "wsl.exe")
		local index
		for i, value in ipairs(args) do if value == "--exec" then index = i end end
		assert(index)
		equal(args[index - 2], "--cd")
		equal(args[index - 1], vim.fn.getcwd())
		equal(args[index + 1], "sh")
		args = vim.list_slice(args, index + 2)
	else
		equal(spawned_program, "sh")
	end
	equal(args[1], "-c")
	equal(vim.list_slice(args, 3), { "wezterm-spawn", "printf", "%s", "hello world $HOME $(false)" })
	local_command = { "sh", "-c", args[2], "wezterm-spawn" }
	vim.cmd("WeztermSpawn")
	equal(spawned_opts.args[#spawned_opts.args], vim.env.SHELL or "/bin/sh")
end
vim.fn.has, vim.fn.executable = has, executable

-- Use a real PTY to verify both task completion and the Enter-to-close behavior.
local function run_task(command, expected, interrupt)
	local output = ""
	local job = vim.fn.jobstart(vim.list_extend(vim.deepcopy(local_command), command), {
		pty = true,
		on_stdout = function(_, data) output = output .. table.concat(data, "\n") end,
	})
	assert(job > 0)
	if interrupt then
		assert(vim.wait(2000, function() return output:find("READY", 1, true) ~= nil end))
		vim.fn.chansend(job, "\3")
	end
	assert(vim.wait(2000, function() return output:find("Press Enter to close.", 1, true) ~= nil end), output)
	assert(output:find(expected, 1, true), output)
	equal(vim.fn.jobwait({ job }, 0), { -1 })
	vim.fn.chansend(job, "\n")
	equal(vim.fn.jobwait({ job }, 2000), { 0 })
	return output
end
local output = run_task({ "printf", "%s", "hello world $HOME $(false)" }, "code 0")
assert(output:find("hello world $HOME $(false)", 1, true), output)
run_task({ "sh", "-c", "exit 7" }, "code 7")
run_task({ "sh", "-c", "printf READY; exec sleep 30" }, "Process exited with code", true)
print("PASS: task-only hold, WSL routing, literal arguments, default shell, failure exits, Ctrl-C and Enter-to-close")
