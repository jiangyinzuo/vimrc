return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		branch = "main",
		init = function()
			if require("detect").has_treesitter_cli_executable then
				local pattern = { "c", "cpp", "rust", "java", "lua", "python", "go", "markdown" }
				require("nvim-treesitter").install(pattern)
				vim.api.nvim_create_autocmd("FileType", {
					pattern = pattern,
					callback = function()
						vim.treesitter.start()
					end,
				})
			end
		end,
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
		cond = false,
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
		cond = false,
	},
}
