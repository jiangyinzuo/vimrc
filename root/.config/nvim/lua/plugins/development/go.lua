if require("config").load_plugin.development.golang then
	return {
		{
			-- NOTE: must ensure `go env GOPATH`/bin is in $PATH,
			-- do not use apt install gopls, whose version is (unknown) and can not be parsed by go.nvim.
			"ray-x/go.nvim",
			cond = vim.g.vimrc_lsp == "nvim-lsp" and vim.g.has_go_executable ~= 0,
			dependencies = { -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
				"nvimtools/none-ls.nvim",
			},
			config = function()
				require("go").setup({
					verbose = false, -- debug
					lsp_semantic_highlights = false, -- do not use highlights from gopls so we can use treesitter highlight injection
					lsp_keymaps = false, -- true: use default keymaps defined in go/lsp.lua
					lsp_cfg = {
						capabilities = require("lsp").get_capabilities(),
						settings = {
							gopls = {
								semanticTokens = false, -- disable semantic string tokens so we can use treesitter highlight injection
							},
						},
					},
					-- after go.nvim's on_attach is called, then this on_attach will be called
					lsp_on_client_start = function(client, bufnr)
						local lsp_module = require("lsp")
						lsp_module.attach_navic(client, bufnr)
						lsp_module.attach_inlay_hints(client, bufnr)
					end,
					null_ls = { -- set to false to disable null-ls setup
						golangci_lint = {
							method = { "NULL_LS_DIAGNOSTICS_ON_SAVE", "NULL_LS_DIAGNOSTICS_ON_OPEN" }, -- when it should run
							-- 为了防止和项目的.golangci.yml文件配置冲突，故disable和enable为空
							disable = {}, -- linters to disable empty by default
							enable = {}, -- linters to enable; empty by default
							severity = vim.diagnostic.severity.INFO, -- severity level of the diagnostics
						},
					},
				})
				-- go.nvim
				-- require("go.null_ls").gotest(),
				-- require("go.null_ls").gotest_action(),
				require("null-ls").register(require("go.null_ls").golangci_lint())
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
