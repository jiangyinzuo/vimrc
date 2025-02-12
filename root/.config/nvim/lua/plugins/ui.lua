return {
	{
		"ray-x/guihua.lua",
		event = "VeryLazy",
		lazy = true,
		build = "cd lua/fzy && make",
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		lazy = true,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			input = {
				enabled = true,
			},
			select = {
				-- Set to false to disable the vim.ui.select implementation
				enabled = true,

				-- Priority list of preferred vim.select implementations
				backend = { "fzf", "telescope", "builtin", "nui" },
			},
		},
	},
	-- {
	-- 	"j-hui/fidget.nvim",
	-- 	opts = {
	-- 		notification = {
	-- 			override_vim_notify = false, -- Automatically override vim.notify() with Fidget
	-- 		},
	-- 	},
	-- },
}
