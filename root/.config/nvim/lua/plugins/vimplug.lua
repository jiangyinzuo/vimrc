vim.api.nvim_command("source ~/.vim/vimrc.d/plugin_setup.vim")
vim.api.nvim_command("source ~/.vim/vimrc.d/ai.vim")

local M = {
	-- SQLComplete: the dbext plugin must be loaded for dynamic SQL completion https://github.com/neovim/neovim/issues/14433
	-- let g:omni_sql_default_compl_type = 'syntax'
	{
		"vim-scripts/dbext.vim",
		ft = "sql",
	},
	"jiangyinzuo/bd.vim",
	{
		"lervag/vimtex",
		ft = "tex",
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/latex.vim")
		end,
	},
	-- Alternatives:
	-- https://github.com/jackMort/ChatGPT.nvim
	-- https://github.com/dpayne/CodeGPT.nvim
	-- https://github.com/Robitx/gp.nvim
	"madox2/vim-ai",
	-- Ref: https://github.com/ibhagwan/fzf-lua
	{ "junegunn/fzf", build = "./install --bin" },
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/fzf.vim")
		end,
	},
	{ "heavenshell/vim-pydocstring", ft = "python" },
	{ "imbue-ai/jupyter_ascending.vim", ft = "python" },
	{
		"voldikss/vim-floaterm",
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/floaterm.vim")
		end,
	},
	{
		"voldikss/fzf-floaterm",
		dependencies = {
			"junegunn/fzf",
			"voldikss/vim-floaterm",
		},
	},
	{
		"skywind3000/asynctasks.vim",
		dependencies = {
			"skywind3000/asyncrun.vim",
		},
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/asynctasks.vim")
		end,
	},
	"justinmk/vim-sneak",
	"matze/vim-move",
	"ap/vim-css-color",
	{
		"LunarWatcher/auto-pairs",
		config = function()
			-- 设置特定于文件类型的自动配对
			vim.g.AutoPairs = vim.fn["autopairs#AutoPairsDefine"]({
				{ open = "<", close = ">", filetype = { "html" } },
			})
			-- 设置 vifm 的自动配对与 vim 相同
			vim.g.AutoPairsLanguagePairs["vifm"] = vim.g.AutoPairsLanguagePairs["vim"]
		end,
	},
	{
		"jiangyinzuo/vim-visual-multi",
		branch = "master",
	},
	"vim-test/vim-test",
	"simnalamburt/vim-mundo",
	"aperezdc/vim-template",
	"szw/vim-maximizer",
	"tpope/vim-characterize",
	{
		"brooth/far.vim",
		cmd = { "Far", "Farf", "Farp", "Farr" },
	},
	"preservim/vimux",
	"honza/vim-snippets",
	"voldikss/vim-translator",
	"romainl/vim-qf",
	{
		"mechatroner/rainbow_csv",
		ft = "csv",
	},
	"jiangyinzuo/open-gitdiff.vim",
	"andrewradev/linediff.vim",
	"tpope/vim-surround",
	"tpope/vim-eunuch",
	"AndrewRadev/splitjoin.vim",
	"tpope/vim-abolish",
	"arthurxavierx/vim-caser",
	"preservim/tagbar",
	"liuchengxu/vista.vim",
	"samoshkin/vim-mergetool",
	"godlygeek/tabular",
	{ "axvr/org.vim", ft = "org" },
	{ "kaarmu/typst.vim", ft = "typst" },
	-- take place of 'airblade/vim-gitgutter',
	{
		"lewis6991/gitsigns.nvim",
		config = require("plugins_setup").gitsigns,
	},
	"tpope/vim-fugitive",
	"junegunn/gv.vim",
	{ "alepez/vim-gtest", ft = { "c", "cpp", "cuda" } },
	-- Alternatives: https://github.com/HakonHarnes/img-clip.nvim
	"jiangyinzuo/img-paste.vim",
	"skywind3000/vim-quickui",
	"pechorin/any-jump.vim",
	{ "jupyter-vim/jupyter-vim", cmd = { "JupyterConnect" } },
	"goerz/jupytext.vim",
	{ "jpalardy/vim-slime", ft = { "python", "ocaml" } },
	{ "whonore/Coqtail", ft = "coq" },
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

	"lambdalisue/fern.vim",
	{
		"lambdalisue/fern-renderer-nerdfont.vim",
		dependencies = {
			"lambdalisue/fern.vim",
			"lambdalisue/nerdfont.vim",
		},
	},
	{
		"lambdalisue/fern-hijack.vim",
		dependencies = {
			"lambdalisue/fern.vim",
		},
	},
	{
		"LumaKernel/fern-mapping-fzf.vim",
		dependencies = {
			"lambdalisue/fern.vim",
		},
	},
	{
		"Yggdroot/LeaderF",
		build = ":LeaderfInstallCExtension",
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/leaderf.vim")
		end,
		dependencies = {
			"skywind3000/Leaderf-snippet",
			"voldikss/LeaderF-emoji",
		},
	},
}

if vim.g.vimrc_lsp == "coc.nvim" then
	table.insert(M, {
		"SirVer/ultisnips",
	})
end
return M
