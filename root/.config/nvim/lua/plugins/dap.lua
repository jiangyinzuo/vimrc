-- alternate: https://github.com/sakhnik/nvim-gdb
if vim.g.vim_dap == "nvim-dap" then
	return {
		{
			"rcarriga/nvim-dap-ui",
			event = "VeryLazy",
			dependencies = {
				"mfussenegger/nvim-dap",
				"nvim-neotest/nvim-nio",
				"theHamsta/nvim-dap-virtual-text",
				"mfussenegger/nvim-dap-python",
			},
			config = require("dapconfig").dapconfig,
		},
		{
			"mfussenegger/nvim-dap",
			event = "VeryLazy",
			lazy = true,
			config = function()
				vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
			end,
		},
		{
			"mfussenegger/nvim-dap-python",
			event = "VeryLazy",
			lazy = true,
			dependencies = {
				"mfussenegger/nvim-dap",
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			event = "VeryLazy",
			lazy = true,
			opts = {
				commented = true,
			},
		},
	}
else
	return {}
end
