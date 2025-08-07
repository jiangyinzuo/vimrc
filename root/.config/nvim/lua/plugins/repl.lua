return {
	{
		"SUSTech-data/neopyter",
		cond = vim.fn.has('wsl'),
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
		"Vigemus/iron.nvim",
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")
			local common = require("iron.fts.common")
			iron.setup({
				config = {
					-- Whether a repl should be discarded or not
					scratch_repl = true,
					-- Your repl definitions come here
					repl_definition = {
						sh = {
							-- Can be a table or a function that
							-- returns a table (see below)
							command = { "bash" },
						},
						python = {
							command = { "ipython", "--no-autoindent" },
							format = common.bracketed_paste_python,
							block_dividers = { "# %%", "#%%" },
						},
						lua = {
							command = { "lua" },
							format = common.bracketed_paste_lua,
						},
					},
					-- set the file type of the newly created repl to ft
					-- bufnr is the buffer id of the REPL and ft is the filetype of the
					-- language being used for the REPL.
					repl_filetype = function(bufnr, ft)
						return ft
						-- or return a string name such as the following
						-- return "iron"
					end,
					-- How the repl window will be displayed
					-- See below for more information
					repl_open_cmd = view.split.vertical.botright("40%"),

					-- repl_open_cmd can also be an array-style table so that multiple
					-- repl_open_commands can be given.
					-- When repl_open_cmd is given as a table, the first command given will
					-- be the command that `IronRepl` initially toggles.
					-- Moreover, when repl_open_cmd is a table, each key will automatically
					-- be available as a keymap (see `keymaps` below) with the names
					-- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
					-- For example,
					--
					-- repl_open_cmd = {
					--   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
					--   view.split.rightbelow("%25")  -- cmd_2: open a repl below
					-- }
				},
				-- Iron doesn't set keymaps by default anymore.
				-- You can set them here or manually add keymaps to the functions in iron.core
				keymaps = {
					toggle_repl = "<space>rr", -- toggles the repl open and closed.
					-- If repl_open_command is a table as above, then the following keymaps are
					-- available
					-- toggle_repl_with_cmd_1 = "<space>rv",
					-- toggle_repl_with_cmd_2 = "<space>rh",
					restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
					send_motion = "<space>sc",
					visual_send = "<space>sc",
					send_file = "<space>sf",
					send_line = "<space>sl",
					send_paragraph = "<space>sp",
					send_until_cursor = "<space>su",
					send_mark = "<space>sm",
					send_code_block = "<space>sb",
					send_code_block_and_move = "<space>sn",
					mark_motion = "<space>mc",
					mark_visual = "<space>mc",
					remove_mark = "<space>md",
					cr = "<space>s<cr>",
					interrupt = "<space>s<space>",
					exit = "<space>sq",
					clear = "<space>cl",
				},
				-- If the highlight is on, you can change how it looks
				-- For the available options, check nvim_set_hl
				highlight = {
					italic = true,
				},
				ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
			})

			-- iron also has a list of commands, see :h iron-commands for all available commands
			-- vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
			-- vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
		end,
	},
}
