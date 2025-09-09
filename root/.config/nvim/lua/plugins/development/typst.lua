if require("config").load_plugin.development.typst then
	local has_typst_executable = require("detect").has_typst_executable

	return {
		-- based on tinymist
		{
			"chomosuke/typst-preview.nvim",
			cond = has_typst_executable,
			ft = "typst",
			build = function()
				require("typst-preview").update()
			end,
		},
		{
			"kaarmu/typst.vim",
			cond = has_typst_executable,
			ft = "typst",
		},
	}
else
	return {}
end
