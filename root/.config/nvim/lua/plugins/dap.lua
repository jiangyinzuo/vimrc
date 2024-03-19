if vim.g.vim_dap == 'nvim-dap' then
	return {
		{
			'rcarriga/nvim-dap-ui',
			lazy = true,
			cmd = {
				"DapContinue",
				"DapToggleRepl",
				"DapSetLogLevel",
				"DapLoadLaunchJSON",
				"DapToggleBreakpoint",
			},
			dependencies = {
				'mfussenegger/nvim-dap',
				"nvim-neotest/nvim-nio",
				'theHamsta/nvim-dap-virtual-text',
			},
			config = require('dapconfig').dapconfig
		},
		{
			'theHamsta/nvim-dap-virtual-text',
			lazy = true,
			opts = {
				commented = true
			}
		},
	}
else
	return {}
end
