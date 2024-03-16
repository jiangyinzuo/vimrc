local lualine = {
	'nvim-lualine/lualine.nvim',
	config = require('plugins_setup').lualine,
}

if vim.g.vimrc_lsp == 'nvim-lsp' then
	lualine.dependencies = {
		"neovim/nvim-lspconfig",
		"linrongbin16/lsp-progress.nvim",
	}
	local lsp = require('lsp.init')
	return {
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				'SmiteshP/nvim-navic',
				'p00f/clangd_extensions.nvim'
			},
			config = lsp.lspconfig,
		},
		{
			"linrongbin16/lsp-progress.nvim",
			config = require("lsp.lsp_progress").lsp_progress,
		},
		'folke/neodev.nvim',
		{
			"hedyhli/outline.nvim",
			lazy = true,
			cmd = { "Outline", "OutlineOpen" },
			opts = {
				-- Your setup opts here
			},
		},
		{
			'mrcjkb/rustaceanvim',
			version = '^4', -- Recommended
			ft = { 'rust' },
		},
		lualine,
	}
else
	lualine.dependencies = {
		"neoclide/coc.nvim",
	}
	return {
		{
			'neoclide/coc.nvim',
			branch = 'release',
			init = function()
				vim.cmd [[source ~/.vim/vimrc.d/coc.vim]]
			end,
		},
		lualine,
	}
end
