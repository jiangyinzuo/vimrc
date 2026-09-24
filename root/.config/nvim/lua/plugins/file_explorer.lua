vim.g.loaded_nvim_dir_plugin = 1

return {
	-- oil.nvim implements WillRenameFiles Request that neovim LSP does not support.
	-- See also:
	-- https://github.com/neovim/neovim/issues/20784
	-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_willRenameFiles
	{
		"stevearc/oil.nvim",
		config = function()
			local detail = false
			require("oil").setup({
				default_file_explorer = true,
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = false,
				},
				keymaps = {
					["gd"] = {
						desc = "Toggle file detail view",
						callback = function()
							detail = not detail
							if detail then
								require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
							else
								require("oil").set_columns({ "icon" })
							end
						end,
					},
				},
				win_options = {
					winbar = "%!v:lua.get_oil_winbar()",
				},
			})
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		version = "*", -- use the latest stable version
		event = "VeryLazy",
		cond = false and vim.fn.executable("yazi") == 1,
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				"<leader>ya",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
		},
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
			"jiangyinzuo/neo-tree-hierarchy.nvim",
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			sources = {
				"filesystem",
				"buffers",
				"git_status",
				"document_symbols",
				"call_hierarchy",
				"type_hierarchy",
			},
			source_selector = {
				winbar = true,
				statusline = false,
			},
			filesystem = {
				hijack_netrw_behavior = "disabled",
				window = {
					mappings = {
						["O"] = {
							command = function(state)
								local node = state.tree:get_node()
								local path = node and node:get_id()
								if path then
									require("oil").open(vim.fs.dirname(path))
								end
							end,
							desc = "打开目录",
						},
					},
				},
			},
			call_hierarchy = {
				client_filters = "first",
			},
			type_hierarchy = {
				client_filters = "first",
			},
		},
		keys = {
			{
				"<leader>nt",
				mode = { "n" },
				"<cmd>Neotree toggle<cr>",
				desc = ":Neotree toggle",
			},
			{
				"<leader>o",
				mode = { "n" },
				"<cmd>Neotree toggle document_symbols<cr>",
				desc = ":Neotree document_symbols",
			}
		},
	},
}
