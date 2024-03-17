if vim.g.vim_dap == 'nvim-dap' then
	return {
		{
			'rcarriga/nvim-dap-ui',
			dependencies = {
				'mfussenegger/nvim-dap',
			},
			config = require('dapconfig').dapconfig
		},
		{
			'theHamsta/nvim-dap-virtual-text',
			opts = {
				commented = true
			}
		},
	}
else
	return {}
end
