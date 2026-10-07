if require("config").load_plugin.development.writing then
	return {
		-- based on tinymist
		{
			"chomosuke/typst-preview.nvim",
			ft = 'typst',
			config = function()
				require("typst-preview").setup({})
			end,
		},
		{
			"kaarmu/typst.vim",
			ft = "typst",
		},
	}
else
	return {}
end
