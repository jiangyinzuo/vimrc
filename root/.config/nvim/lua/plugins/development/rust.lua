if require("config").load_plugin.development.rust then
	return {
		{
			"mrcjkb/rustaceanvim",
			cond = require("detect").has_rust_executable,
			lazy = false, -- This plugin is already lazy, do not need ft = {'rust'}
		},
	}
else
	return {}
end
