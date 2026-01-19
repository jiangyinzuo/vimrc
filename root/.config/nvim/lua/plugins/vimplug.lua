local leaderf_dependencies = {
	"voldikss/LeaderF-emoji",
}
if vim.g.vimrc_lsp == "coc.nvim" then
	table.insert(leaderf_dependencies, "skywind3000/Leaderf-snippet")
end

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
	"voldikss/vim-floaterm",
	{
		"voldikss/fzf-floaterm",
		event = "VeryLazy",
		dependencies = {
			"junegunn/fzf",
			"voldikss/vim-floaterm",
		},
	},
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
	{
		"jiangyinzuo/vim-visual-multi",
		branch = "master",
	},
	-- TODO: see https://github.com/nvim-neotest/neotest
	{
		"vim-test/vim-test",
		event = "VeryLazy",
	},
	"simnalamburt/vim-mundo",
	"aperezdc/vim-template",
	"szw/vim-maximizer",
	"wesQ3/vim-windowswap",
	"tpope/vim-characterize",
	"tpope/vim-speeddating",
	{
		"preservim/vimux",
		cond = vim.fn.executable("tmux") ~= 0,
	},
	"honza/vim-snippets",
	{
		"voldikss/vim-translator",
		cond = require("config").load_plugin.public_network
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
	"pechorin/any-jump.vim",
	{ "jiangyinzuo/vim-markdown", ft = {"markdown", "quarto"} },
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
	{
		"SirVer/ultisnips",
		cond = vim.g.vimrc_lsp == "coc.nvim",
	},
}

return M
