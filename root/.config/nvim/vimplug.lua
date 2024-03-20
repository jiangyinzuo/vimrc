local plugins_setup = require("plugins_setup")

plugins_setup.nvim_treesitter()
plugins_setup.telescope()
plugins_setup.mason()
plugins_setup.gitsigns()

local neodev_config = {}
if vim.g.vim_dap == 'nvim-dap' then
	require("dapconfig").dapconfig()
	require("nvim-dap-virtual-text").setup({
		commented = true,
	})
	neodev_config = {
		-- add any options here, or leave empty to use the default settings
		library = { plugins = { "nvim-dap-ui" }, types = true },
	}
end

if vim.g.vimrc_lsp == 'nvim-lsp' then
	-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
	require("neodev").setup(neodev_config)
	require("lsp.init").lspconfig()
	require("lsp.lsp_progress").lsp_progress()
	require("outline").setup()
end

plugins_setup.lualine()
require('nvim_cmp').nvim_cmp()

require("CopilotChat").setup {
	debug = true, -- Enable debugging
	-- See Configuration section for rest
}

require("nvim-devdocs").setup{}

-- load colorscheme at the end to avoid black background on startup
plugins_setup.colorscheme()
