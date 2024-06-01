local M = {}

function M.dapconfig()
	local dap, dapui = require("dap"), require("dapui")
	dapui.setup()

	-- 自动开启/关闭dapui
	dap.listeners.before.attach.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.launch.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated.dapui_config = function()
		dapui.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
		dapui.close()
	end

	vim.api.nvim_create_user_command("DapUiClose", function(opts)
		dapui.close()
	end, { nargs = 0 })
	-- c, cpp, rust
	-- 调试有控制台输入输出的程序时，由于gdb的一个issue(https://github.com/microsoft/vscode-cpptools/issues/3953)，
	-- printf必须输出\n，或者手动fflush(stdout)/setbuf(stdout, NULL)后，才能在console中看到输出。
	--
	-- 向控制台输入时，切换到console 窗口（element）需要通过CTRL-W hjkl，输入完后先鼠标单击代码窗口，再鼠标单击REPL窗口，
	-- 防止出现"Debug adapter reported a frame at line 12 column 1, but: Cursor position outside buffer. Ensure executable is up2date and if using a source mapping ensure it is correct"这样的错误
	dap.adapters.cppdbg = {
		id = "cppdbg",
		type = "executable",
		command = "OpenDebugAD7",
	}

	-- TODO: Data Visualization? https://github.com/vadimcn/codelldb/wiki/Data-visualization
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			-- CHANGE THIS to your path!
			command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
			args = { "--port", "${port}" },

			-- On windows you may have to uncomment this:
			-- detached = false,
		},
	}

	dap.configurations.cpp = {
		{
			name = "Launch debugger(codelldb)",
			type = "codelldb",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			stopOnEntry = false,
		},
		{
			name = "Launch file(cppdbg)",
			type = "cppdbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = true,
		},
		{
			name = "Attach to gdbserver :1234(cppdbg)",
			type = "cppdbg",
			request = "launch",
			MIMode = "gdb",
			miDebuggerServerAddress = "localhost:1234",
			miDebuggerPath = "/usr/bin/gdb",
			cwd = "${workspaceFolder}",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
		},
	}
	for _, language in ipairs({ "c", "rust" }) do
		-- append dap.configurations[language] with gdb configurations
		dap.configurations[language] = dap.configurations["cpp"]
	end

	require("dap-python").setup("python3")
	vim.api.nvim_create_user_command("DapPytestMethod", function(_)
		local dap_python = require("dap-python")
		dap_python.test_runner = "pytest"
		dap_python.test_method()
	end, { nargs = 0 })
end

return M
