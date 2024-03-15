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

function _G.copilotChatInit()
	require("CopilotChat").setup {
		debug = true, -- Enable debugging
		-- See Configuration section for rest
	}
end

-- 创建命令调用该函数
-- 适用于 Neovim 0.7 及以上版本
vim.api.nvim_create_user_command('CopilotChatInit', copilotChatInit, {})
