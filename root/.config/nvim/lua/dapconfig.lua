-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
	library = { plugins = { "nvim-dap-ui" }, types = true },
})

local dap, dapui = require("dap"), require("dapui")
dapui.setup({
	layouts = {
		{
			elements = {
				-- Provide as ID strings or tables with "id" and "size" keys
				{
					id = "scopes",
					size = 0.2, -- Can be float or integer > 1
				},
				{ id = "breakpoints", size = 0.2 },
				{ id = "stacks",      size = 0.2 },
				{ id = "watches",     size = 0.2 },
				{ id = "console",     size = 0.2 }
			},
			size = 40,
			position = "left",
		},
		{ elements = { "repl" }, size = 10, position = "bottom" },
	},
	-- Requires Nvim version >= 0.8
	controls = {
		enabled = true,
		-- Display controls in this session
		element = "repl",
	},
	floating = {
		max_height = nil,
		max_width = nil,
		mappings = { close = { "q", "<Esc>" } },
	},
	windows = { indent = 1 },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.api.nvim_create_user_command('DapUiClose', function(opts) dapui.close() end, { nargs = 0 })
-- c, cpp, rust
-- 调试有控制台输入输出的程序时，由于gdb的一个issue(https://github.com/microsoft/vscode-cpptools/issues/3953)，
-- printf必须输出\n，或者手动fflush(stdout)/setbuf(stdout, NULL)后，才能在console中看到输出。
--
-- 向控制台输入时，切换到console 窗口（element）需要通过CTRL-W hjkl，输入完后先鼠标单击代码窗口，再鼠标单击REPL窗口，
-- 防止出现"Debug adapter reported a frame at line 12 column 1, but: Cursor position outside buffer. Ensure executable is up2date and if using a source mapping ensure it is correct"这样的错误
dap.adapters.cppdbg = {
	id = 'cppdbg',
	type = 'executable',
	command = 'OpenDebugAD7',
}

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopAtEntry = true,
	},
	{
		name = 'Attach to gdbserver :1234',
		type = 'cppdbg',
		request = 'launch',
		MIMode = 'gdb',
		miDebuggerServerAddress = 'localhost:1234',
		miDebuggerPath = '/usr/bin/gdb',
		cwd = '${workspaceFolder}',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- pip install debugpy
dap.adapters.python = {
	type = 'executable',
	command = 'python3',
	args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
	-- same as vscode launch.json
	{
		-- The first three options are required by nvim-dap
		type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = 'launch',
		name = "Launch file",
		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
		console = "integratedTerminal",
		program = "${file}", -- This configuration will launch the current file if used.
		pythonPath = 'python3',
	},
}

require("nvim-dap-virtual-text").setup({
	commented = true,
})
