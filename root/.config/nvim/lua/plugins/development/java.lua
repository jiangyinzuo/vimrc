if require("config").load_plugin.development.java then
	return {
		{
			"mfussenegger/nvim-jdtls",
		}
	}
else
	return {}
end

