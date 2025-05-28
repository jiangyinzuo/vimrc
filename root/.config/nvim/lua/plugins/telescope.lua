return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		keys = {
			"<leader>fb",
			"<leader>ff",
			"<leader>fh",
			"<leader>ft",
			"<leader>rg",
		},
		cmd = { "Telescope" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"aaronhallaert/advanced-git-search.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"rmagatti/auto-session",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-bibtex.nvim",
			-- "benfowler/telescope-luasnip.nvim",
			"2kabhishek/nerdy.nvim",
			"albenisolmos/telescope-oil.nvim",
		},
		config = function()
			local layout_strategy
			if vim.o.columns <= 125 then
				layout_strategy = "vertical"
			else
				layout_strategy = "horizontal"
			end
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({ layout_strategy = layout_strategy })
			end, {})
			vim.keymap.set("n", "<leader>rg", builtin.grep_string, {})
			vim.keymap.set("x", "<leader>rg", builtin.grep_string, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.oldfiles, {})

			local telescope = require("telescope")
			telescope.setup({
				extensions = {
					advanced_git_search = {
						-- See Config
						git_flags = { "-c", "delta.pager=never" },
					},
					bibtex = {
						-- Depth for the *.bib file
						depth = 999,
						-- Custom format for citation label
						custom_formats = {},
						-- Format to use for citation label.
						-- Try to match the filetype by default, or use 'plain'
						format = "",
						-- Path to global bibliographies (placed outside of the project)
						global_files = {},
						-- Define the search keys to use in the picker
						search_keys = { "year", "title" },
						-- Template for the formatted citation
						citation_format = "{{author}} ({{year}}), {{title}}.",
						-- Only use initials for the authors first name
						citation_trim_firstname = true,
						-- Max number of authors to write in the formatted citation
						-- following authors will be replaced by "et al."
						citation_max_auth = 2,
						-- Context awareness disabled by default
						context = false,
						-- Fallback to global/directory .bib files if context not found
						-- This setting has no effect if context = false
						context_fallback = true,
						-- Wrapping in the preview window is disabled by default
						wrap = false,
					},
					media_files = {
						-- filetypes whitelist
						-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
						filetypes = { "png", "webp", "jpg", "jpeg" },
						-- find command (defaults to `fd`)
						find_cmd = "fd",
					},
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
				},
			})

			telescope.load_extension("media_files")
			telescope.load_extension("fzf")
			telescope.load_extension("advanced_git_search")
			telescope.load_extension("session-lens")
			telescope.load_extension("bibtex")
			-- telescope.load_extension("luasnip")
			telescope.load_extension("nerdy")
			telescope.load_extension("oil")

			vim.keymap.set("n", "<leader>to", "<cmd>Telescope oil<CR>", { noremap = true, silent = true })
		end,
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
