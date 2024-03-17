local plugins_setup = require("plugins_setup")

plugins_setup.nvim_treesitter()
plugins_setup.telescope()
plugins_setup.mason()

if vim.g.vimrc_lsp == 'nvim-lsp' then
	require("lsp.init").lspconfig()
	require("lsp.lsp_progress").lsp_progress()
	require("dapconfig")
	require("outline").setup()
end

plugins_setup.lualine()
require('nvim_cmp').nvim_cmp()

require("CopilotChat").setup {
	debug = true, -- Enable debugging
	-- See Configuration section for rest
}

-- load colorscheme at the end to avoid black background on startup
plugins_setup.colorscheme()
