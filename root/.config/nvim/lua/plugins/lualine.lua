local lualine = {
	"nvim-lualine/lualine.nvim",
	event = "UIEnter",
}

if vim.g.ai_complete == "copilot" or vim.g.avante_auto_suggestions_enabled == 0 then
	lualine.dependencies = {
		"AndreM222/copilot-lualine"
	}
end

if vim.g.vimrc_lsp == "nvim-lsp" then
	table.insert(lualine.dependencies, "neovim/nvim-lspconfig")
	table.insert(lualine.dependencies, "linrongbin16/lsp-progress.nvim")
else
	table.insert(lualine.dependencies, "neoclide/coc.nvim")
end

return lualine
