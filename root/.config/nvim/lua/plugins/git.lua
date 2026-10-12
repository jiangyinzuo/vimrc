return {
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"jiangyinzuo/conflict-marker.nvim",
	},
	{
		"aaronhallaert/advanced-git-search.nvim",
		dependencies = {
			"dlyongemallo/diffview-plus.nvim",
		},
	},
	{
		"georgeguimaraes/review.nvim",
		version = "*",
		dependencies = {
			"esmuellert/codediff.nvim",
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
		keys = {
			{ "<leader>rr", "<cmd>Review<cr>", desc = "Review working tree" },
			{ "<leader>rc", "<cmd>Review commits<cr>", desc = "Review commits" },
			{ "<leader>rb", "<cmd>Review branch<cr>", desc = "Review branch" },
			{ "<leader>rn", ":Review note<cr>", mode = { "n", "v" }, desc = "Review: note here" },
			{ "<leader>re", "<cmd>Review edit<cr>", desc = "Review: edit comment" },
			{ "<leader>rd", "<cmd>Review delete<cr>", desc = "Review: delete comment" },
			{ "<leader>rx", "<cmd>Review export<cr>", desc = "Review: export" },
		},
		opts = {},
	},
	{
		"dlyongemallo/diffview-plus.nvim",
		version = "*",
		opts = {
			enhanced_diff_hl = true,
			diffopt = { algorithm = "histogram" },
			view = {
				merge_tool = {
					layout = "diff4_mixed",
					disable_diagnostics = true,
					winbar_info = true,
				},
				cycle_layouts = {
					merge_tool = { "diff4_mixed", "diff3_mixed", "diff3_horizontal", "diff1_plain" },
				},
			},
		},
		-- optional: lazy-load on command
		-- cmd = {
		--     "DiffviewOpen",
		--     "DiffviewToggle",
		--     "DiffviewFileHistory",
		--     "DiffviewDiffFiles",
		--     "DiffviewLog",
		-- },
	},
	-- take place of 'airblade/vim-gitgutter',
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- 比默认priority低1级, bookmarkspriority为10
			sign_priority = 9,
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Unstaged hunk navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Staged hunk navigation
				map("n", "]sc", function()
					gitsigns.nav_hunk("next", { target = "staged" })
				end)
				map("n", "[sc", function()
					gitsigns.nav_hunk("prev", { target = "staged" })
				end)

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
			base = vim.g.gitsign_default_base,
			current_line_blame_opts = {
				delay = 100,
			},
		},
	},
	"tpope/vim-fugitive",
	"jiangyinzuo/open-gitdiff.vim",
}
