if vim.fn.has("wsl") == 1 then
	return {
		{
			"Febri-i/snake.nvim",
			dependencies = {
				"Febri-i/fscreen.nvim",
			},
			opts = {},
		},
		{
			"alanfortlink/blackjack.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"ActionScripted/tetris.nvim",
			cmd = { "Tetris" },
			keys = { { "<leader>T", "<cmd>Tetris<cr>", desc = "Tetris" } },
			opts = {
				-- your awesome configuration here
			},
		}
	}
else
	return {}
end
