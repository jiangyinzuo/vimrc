if vim.g.vimrc_lsp == "nvim-lsp" and require("config").load_plugin.development.extra then
	return {
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			priority = 501,
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	}
else
	return {}
end
