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
					exec = vim.g.tag_system,
				},
			},
		},
		{
			"p00f/godbolt.nvim",
			cond = require("config").load_plugin.public_network,
			opts = {
				{
					languages = {
						cpp = { compiler = "g122", options = {} },
						c = { compiler = "cg122", options = {} },
						rust = { compiler = "r1650", options = {} },
						-- any_additional_filetype = { compiler = ..., options = ... },
					},
					auto_cleanup = true, -- remove highlights and autocommands on buffer close
					highlight = {
						cursor = "Visual", -- `cursor = false` to disable
						-- values in this table can be:
						-- 1. existing highlight group
						-- 2. hex color string starting with #
						static = { "#222222", "#333333", "#444444", "#555555", "#444444", "#333333" },
						-- `static = false` to disable
					},
					-- `highlight = false` to disable highlights
					quickfix = {
						enable = false, -- whether to populate the quickfix list in case of errors
						auto_open = false, -- whether to open the quickfix list in case of errors
					},
					url = "https://godbolt.org", -- can be changed to a different godbolt instance
				},
			},
		},
	}
else
	return {}
end
