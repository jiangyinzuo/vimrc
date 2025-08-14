return {
	{
		"SUSTech-data/neopyter",
		cond = vim.fn.has('wsl') == 1,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter", -- neopyter don't depend on `nvim-treesitter`, but does depend on treesitter parser of python
			"AbaoFromCUG/websocket.nvim", -- for mode='direct'
		},

		---@type neopyter.Option
		opts = {
			mode = "direct",
			remote_address = "127.0.0.1:9001",
			file_pattern = { "*.ju.*" },
			---@type neopyter.ParserOption  # ref `:h neopyter.ParserOption`
			on_attach = function(buf)
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = buf })
				end
				-- same, recommend the former
				map("n", "<leader>rc", "<cmd>Neopyter execute notebook:run-cell<cr>", "run selected")
				-- map("n", "<C-Enter>", "<cmd>Neopyter run current<cr>", "run selected")

				-- same, recommend the former
				map("n", "<leader>ra", "<cmd>Neopyter execute notebook:run-all-above<cr>", "run all above cell")
				-- map("n", "<space>X", "<cmd>Neopyter run allAbove<cr>", "run all above cell")

				-- same, recommend the former, but the latter is silent
				-- map("n", "<leader>nt", "<cmd>Neopyter execute kernelmenu:restart<cr>", "restart kernel")
				-- map("n", "<leader>nt", "<cmd>Neopyter kernel restart<cr>", "restart kernel")

				-- map(
				-- 	"n",
				-- 	"<S-Enter>",
				-- 	"<cmd>Neopyter execute notebook:run-cell-and-select-next<cr>",
				-- 	"run selected and select next"
				-- )
				-- map(
				-- 	"n",
				-- 	"<M-Enter>",
				-- 	"<cmd>Neopyter execute notebook:run-cell-and-insert-below<cr>",
				-- 	"run selected and insert below"
				-- )

				map("n", "<F5>", "<cmd>Neopyter execute notebook:restart-run-all<cr>", "restart kernel and run all")

				local Popup = require("nui.popup")
				local help_popup = Popup({
					enter = false,
					focusable = false,
					border = {
						style = "rounded",
						text = {
							top = " Neopyter Help ",
						},
					},
					position = {
						row = "1%",
						col = "99%",
					},
					size = {
						width = "40",
						height = "4",
					},
					buf_options = {
						modifiable = true,
						readonly = false,
					},
				})
				help_popup:mount()
				-- set content
				vim.api.nvim_buf_set_lines(help_popup.bufnr, 0, 1, false, {
					"<leader>rc - Run current cell",
					"<leader>ra - Run all above cells",
					"<F5> - Restart kernel and run all",
					"<F1> - Toggle this help",
				})
				local help_popup_is_shown = true
				map("n", "<F1>", function()
					if help_popup_is_shown then
						help_popup:hide()
					else
						help_popup:update_layout({
							relative = "win",
							position = {
								row = "1%",
								col = "99%",
							},
						})
						help_popup:show()
					end
					help_popup_is_shown = not help_popup_is_shown
				end, "toggle help popup")
			end,
		},
	},
	{
		"goerz/jupytext.nvim",
		opts = {},
	},
}
