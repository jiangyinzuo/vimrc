local plugins_setup = require("plugins_setup")

plugins_setup.nvim_treesitter()
plugins_setup.telescope()
plugins_setup.mason()
plugins_setup.gitsigns()
plugins_setup.auto_session()

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

if vim.g.ai_complete == 'copilot' then
	require("CopilotChat").setup {
		debug = true, -- Enable debugging
		-- See Configuration section for rest
	}
elseif vim.g.ai_complete == 'fittencode' then
	require('fittencode').setup()
end

require("nvim-devdocs").setup{}
require('Comment').setup()
require("todo-comments").setup()

-- load colorscheme at the end to avoid black background on startup
plugins_setup.colorscheme()
