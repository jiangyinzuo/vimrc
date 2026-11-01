-- 命令行jupyter运行/预览：euporie
-- pip install jupyter-collaboration
if require("config").load_plugin.development.jupyter then
	return {
		{
			"GCBallesteros/jupytext.nvim",
			opts = {
				custom_language_formatting = {
					python = {
						extension = "md",
						style = "markdown",
						force_ft = "markdown", -- you can set whatever filetype you want here
					},
				},
			},
		},
	}
else
	return {}
end
