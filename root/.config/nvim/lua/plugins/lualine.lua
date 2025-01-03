local lualine = {
	"nvim-lualine/lualine.nvim",
	event = "UIEnter",
	dependencies = {}
}

-- WARN: DO NOT USE AndreM222/copilot-lualine

if vim.g.vimrc_lsp == "nvim-lsp" then
	table.insert(lualine.dependencies, "neovim/nvim-lspconfig")
	table.insert(lualine.dependencies, "linrongbin16/lsp-progress.nvim")
else
	table.insert(lualine.dependencies, "neoclide/coc.nvim")
end

return lualine
