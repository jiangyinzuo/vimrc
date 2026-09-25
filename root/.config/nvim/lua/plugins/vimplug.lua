local leaderf_dependencies = {
	"voldikss/LeaderF-emoji",
}

local M = {
	-- SQLComplete: the dbext plugin must be loaded for dynamic SQL completion https://github.com/neovim/neovim/issues/14433
	-- let g:omni_sql_default_compl_type = 'syntax'
	-- suda is a plugin to read or write files with sudo command.
	"lambdalisue/vim-suda",
	-- vim-matchup的event不能设置为VeryLazy / VimEnter
	{
		"andymass/vim-matchup",
		opts = {
			treesitter = {
				stopline = 500,
			},
		},
	},
	"jiangyinzuo/bd.vim",
	-- Ref: https://github.com/ibhagwan/fzf-lua
	{ "junegunn/fzf", build = "./install --bin" },
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/fzf.vim")
		end,
	},
	"jiangyinzuo/z.vim",
	{
		"skywind3000/asynctasks.vim",
		event = "VeryLazy",
		dependencies = {
			"skywind3000/asyncrun.vim",
		},
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/asynctasks.vim")
		end,
	},
	"justinmk/vim-sneak",
	"matze/vim-move",
	{
		"norcalli/nvim-colorizer.lua",
		opts = {},
		-- LSP document_color
		cond = false,
	},
	-- TODO: see https://github.com/nvim-neotest/neotest
	{
		"vim-test/vim-test",
		event = "VeryLazy",
	},
	"aperezdc/vim-template",
	"szw/vim-maximizer",
	"wesQ3/vim-windowswap",
	"tpope/vim-characterize",
	"tpope/vim-speeddating",
	"honza/vim-snippets",
	"madox2/vim-ai",
	{
		"echasnovski/mini.diff",
		version = false,
		config = function()
			require("mini.diff").setup({
				source = { name = "live-memory", attach = function() return true end },
				mappings = {
					apply = "",
					reset = "",
					textobject = "",
					goto_first = "",
					goto_prev = "",
					goto_next = "",
					goto_last = "",
				},
				view = {
					style = "sign",
					signs = { add = "▎", change = "▎", delete = "▁" },
					overlay = { style = "default", ref_text = true, context_lines = 3 },
				},
			})
			local function set_diff_colors()
				vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#89d185" })
				vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#e2c08d" })
				vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#f14c4c" })
				vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { bg = "#1e4429" })
				vim.api.nvim_set_hl(0, "MiniDiffOverChange", { bg = "#632525", underline = true })
				vim.api.nvim_set_hl(0, "MiniDiffOverChangeBuf", { bg = "#1e4429", underline = true })
				vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { bg = "#632525", fg = "#ff8b8b", strikethrough = true })
				vim.api.nvim_set_hl(0, "MiniDiffOverContext", { fg = "#808080" })
			end
			set_diff_colors()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diff_colors })
		end,
	},
	{
		"voldikss/vim-translator",
		cond = require("config").load_plugin.public_network,
	},
	"andrewradev/linediff.vim",
	"tpope/vim-surround",
	"tpope/vim-eunuch",
	{
		"tpope/vim-abolish",
		init = function()
			-- Disable coercion mappings. I use coerce.nvim for that.
			vim.g.abolish_no_mappings = true
		end,
	},
	"preservim/tagbar",
	"liuchengxu/vista.vim",
	"samoshkin/vim-mergetool",
	"godlygeek/tabular",
	{ "axvr/org.vim", ft = "org" },
	{
		"inkarkat/vim-AdvancedSorters",
		dependencies = {
			"inkarkat/vim-ingo-library",
		},
	},
	"dhruvasagar/vim-table-mode",
	"tpope/vim-endwise",
	"junegunn/gv.vim",
	-- Alternatives: https://github.com/HakonHarnes/img-clip.nvim
	"jiangyinzuo/img-paste.vim",
	"skywind3000/vim-quickui",
	{
		"pechorin/any-jump.vim",
		init = function()
			vim.g.any_jump_disable_default_keybindings = 1
			vim.keymap.set({ "n" }, "<leader>j", "<cmd>AnyJump<CR>", { desc = ":AnyJump" })
			vim.keymap.set({ "v" }, "<leader>j", "<cmd>AnyJumpVisual<CR>", { desc = ":AnyJumpVisual" })
			vim.keymap.set({ "n" }, "<leader>ab", "<cmd>AnyJumpBack<CR>", { desc = ":AnyJumpBack" })
			vim.keymap.set({ "n" }, "<leader>ao", "<cmd>AnyJumpLastResults<CR>", { desc = ":AnyJumpLastResults" })
		end,
	},
	{
		dir = "~/.vim/pack/my_plugins/start/project.vim",
		dependencies = {
			"skywind3000/asynctasks.vim",
		},
		priority = 2000,
	},
	{
		"jiangyinzuo/codenote",
		dependencies = {
			"tpope/vim-fugitive",
		},
	},
	{ dir = "~/.vim/pack/my_plugins/start/diffbuffer.vim" },
}

return M
