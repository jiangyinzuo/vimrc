local mini_clue_trigger_table = {
	{ mode = "n", keys = "<leader>a", desc = "Avante" },
	{ mode = "n", keys = "<leader>cc", desc = "Claude" },
	{ mode = "n", keys = "<leader>s", desc = "Iron REPL" },
	{ mode = "n", keys = "cr", desc = "Case" },
	{ mode = "x", keys = "<leader>cc", desc = "Claude" },
	{ mode = "x", keys = "<leader>s", desc = "Iron REPL" },
}

return {
	{
		"ray-x/guihua.lua",
		event = "VeryLazy",
		lazy = true,
		build = "cd lua/fzy && make",
	},
	"MunifTanjim/nui.nvim",
	-- {
	-- 	"j-hui/fidget.nvim",
	-- 	opts = {
	-- 		notification = {
	-- 			override_vim_notify = false, -- Automatically override vim.notify() with Fidget
	-- 		},
	-- 	},
	-- },
	{
		"echasnovski/mini.clue",
		version = false,
		opts = {
			triggers = mini_clue_trigger_table,
			clues = {},
			window = {
				-- Floating window config
				config = {
					anchor = "SE",
					width = "auto",
					row = "auto",
					col = "auto",
				},

				-- Delay before showing clue window
				delay = 100,

				-- Keys to scroll inside the clue window
				scroll_down = "<C-d>",
				scroll_up = "<C-u>",
			},
		},
		config = function(_, opts)
			require("mini.clue").setup(opts)

			-- create keymap <leader>? to show all the triggers in floating window
			vim.keymap.set("n", "<leader>?", function()
				local lines = {}
				for _, v in ipairs(mini_clue_trigger_table) do
					local keys = v.keys:gsub(" ", "<space>")
					table.insert(lines, string.format("mode %s - %s - %s", v.mode, keys, v.desc))
				end
				vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Clue Triggers" })
			end)
		end,
	},
	-- {
	-- 	"3rd/image.nvim",
	-- 	build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	-- 	opts = {
	-- 		backend = "kitty",
	-- 		processor = "magick_cli",
	-- 	},
	-- },
}
