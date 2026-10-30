-- 命令行jupyter运行/预览：euporie
-- pip install jupyter-collaboration
if require("config").load_plugin.development.jupyter then
	return {
		{
			"jiangyinzuo/jove.nvim",
			lazy = false, -- 官方建议，确保插件完全加载
			opts = {
				auto_reload = true, -- 开启磁盘变化自动重载
				lsp = {
					auto_attach = true,
					servers = { python = { vim.g.python_lsp } },
				},
			},
		},
		{
			"jiangyinzuo/jupytext-render.nvim",
			main = "jupytext-render",
			event = "VeryLazy",
			dependencies = { "jiangyinzuo/jove.nvim", "MeanderingProgrammer/render-markdown.nvim" },
			opts = {
				render_markdown = true,
				cell_decorations = false,
				ipynb_only = true,
			},
		},
	}
else
	return {}
end
