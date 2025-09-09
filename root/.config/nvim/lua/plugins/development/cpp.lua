if require("config").load_plugin.development.cpp then
	return {
		{ "alepez/vim-gtest", ft = { "c", "cpp", "cuda" } },
		{
			"ranjithshegde/ccls.nvim",
			event = "VimEnter",
			cond = vim.g.vimrc_lsp == "nvim-lsp" and require("detect").has_ccls_executable,
			dependencies = {
				"neovim/nvim-lspconfig",
			},
		},
	}
else
	return {}
end
