return {
	settings = {
		Lua = {
			codeLens = {
				enable = true,
			},
			runtime = {
				version = "LuaJIT",
			},
			format = {
				enable = false,
				defaultConfig = {
					indent_style = "tab",
					indent_size = "2",
				},
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}
