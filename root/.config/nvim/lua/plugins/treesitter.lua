return {
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- 安装 language parser
				-- :TSInstallInfo 命令查看支持的语言
				ensure_installed = {
					"c",
					"cpp",
					"go",
					"lua",
					"vim",
					"vimdoc",
					"python",
					"rust",
					"html",
					"query",
					"markdown",
					"markdown_inline",
				},
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- 启用代码高亮模块
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				-- https://github.com/RRethy/nvim-treesitter-endwise
				endwise = {
					enable = false, -- nvim-treesitter-endwise is not maintained
				},
				-- https://github.com/andymass/vim-matchup
				matchup = {
					enable = true, -- mandatory, false will disable the whole extension
					-- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
					-- [options]
				},
			})
		end,
		dependencies = {
			-- "RRethy/nvim-treesitter-endwise",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 30, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							ib = "@block.inner",
							ab = "@block.outer",
							ic = "@class.inner",
							ac = "@class.outer",
							["if"] = "@function.inner",
							af = "@function.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							-- ["]b"] = "@block.outer",
							["]f"] = "@function.outer",
							["]]"] = { query = "@class.outer", desc = "Next class start" },
						},
						goto_next_end = {
							-- ["]B"] = "@block.outer",
							["]F"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							-- ["[b"] = "@block.outer",
							["[f"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							-- ["[B"] = "@block.outer",
							["[F"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
}
