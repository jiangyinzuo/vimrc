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
	-- try plugins in https://nvimdev.github.io
	return {
		{
			"neovim/nvim-lspconfig",
			priority = 500,
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
		{
			-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
			"folke/neodev.nvim",
			opts = {},
			priority = 501
		},
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
		{
			"ray-x/go.nvim",
			dependencies = {  -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("go").setup()
			end,
			event = {"CmdlineEnter"},
			ft = {"go", 'gomod'},
			-- 该命令在网络环境差的情况下可能会卡顿，故手动执行
			-- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
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
