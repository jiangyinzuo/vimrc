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
		{
			"dhananjaylatkar/cscope_maps.nvim",
			cond = vim.fn.executable(vim.g.tag_system) ~= 0,
			opts = {
				skip_input_prompt = true,
				prefix = "<leader>cs", -- prefix to trigger maps
				cscope = {
					exec = vim.g.tag_system
				}
			},
		},
	}
else
	return {}
end
