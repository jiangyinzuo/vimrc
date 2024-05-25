-- alternate: https://github.com/sakhnik/nvim-gdb
if vim.g.vim_dap == "nvim-dap" then
	return {
		{
			"rcarriga/nvim-dap-ui",
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
			lazy = true,
			config = function()
				vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
			end,
		},
		{
			lazy = true,
			"mfussenegger/nvim-dap-python",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			lazy = true,
			opts = {
				commented = true,
			},
		},
	}
else
	return {}
end
