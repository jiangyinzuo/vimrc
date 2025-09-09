return {
	lazy_nvim_install_missing = false,
	treesitter_ensure_installed = {
		"cpp",
		"python",
		-- "go",
		-- "rust",
		-- "html",
	},
	load_plugin = {
		-- AI plugins that send data to public servers
		ai_public = false,
		development = {
			cpp = true,
			extra = false,
			golang = false,
			java = false,
			jupyter = false,
			rust = false,
		},
	},
}
