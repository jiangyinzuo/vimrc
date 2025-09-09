if require("config").load_plugin.development.rust then
	return {
		{
			"mrcjkb/rustaceanvim",
			cond = require("detect").has_rust_executable,
			-- version = "^5", -- Recommended
			lazy = false, -- This plugin is already lazy
			ft = { "rust" },
		},
	}
else
	return {}
end
