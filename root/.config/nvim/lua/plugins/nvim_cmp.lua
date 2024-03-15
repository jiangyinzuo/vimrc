return {
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'quangnguyen30192/cmp-nvim-ultisnips',
			'p00f/clangd_extensions.nvim',
		},
		config = require('nvim_cmp').nvim_cmp,
	}
}
