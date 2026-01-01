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
		-- AI plugins that can run locally
		ai_local = true,
		-- AI plugins that send data to public servers
		ai_public = false,
		public_network = false,
		development = {
			cpp = true,
			coq = false,
			golang = false,
			java = false,
			jupyter = false,
			lean = false,
			rust = false,
			writing = false,
		},
	},
	minuet_opt = {
		provider = "openai_fim_compatible",
		provider_options = {
			openai_fim_compatible = {
				api_key = "DEEPSEEK_API_KEY",
				name = "deepseek",
				optional = {
					max_tokens = 256,
					top_p = 0.9,
				},
			},
		},
	},
	avante_provider = "openai",
	avante_auto_suggestions_provider = "openai",
	iron_repl_sql_command = { "duckdb" },
}
