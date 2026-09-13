if require("config").load_plugin.development.golang then
	return {
		{
			-- NOTE: must ensure `go env GOPATH`/bin is in $PATH,
			-- do not use apt install gopls, whose version is (unknown) and can not be parsed by go.nvim.
			"ray-x/go.nvim",
			cond = vim.g.has_go_executable ~= 0,
			dependencies = { -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
			},
			config = function()
				require("go").setup({
				})
			end,
			ft = { "go", "gomod" },
			-- 该命令在网络环境差的情况下可能会卡顿，故手动执行
			-- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
		},
		{ "sebdah/vim-delve", cond = vim.g.has_go_executable ~= 0, ft = "go" },
	}
else
	return {}
end
