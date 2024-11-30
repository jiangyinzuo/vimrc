vim.api.nvim_command("source ~/.vim/vimrc.d/plugin_setup.vim")
vim.api.nvim_command("source ~/.vim/vimrc.d/ai.vim")

local leaderf_dependencies = {
	"voldikss/LeaderF-emoji",
}
if vim.g.vimrc_lsp == "coc.nvim" then
	table.insert(leaderf_dependencies, "skywind3000/Leaderf-snippet")
end

local detect = require("detect")

local M = {
	-- SQLComplete: the dbext plugin must be loaded for dynamic SQL completion https://github.com/neovim/neovim/issues/14433
	-- let g:omni_sql_default_compl_type = 'syntax'
	{
		"vim-scripts/dbext.vim",
		ft = "sql",
	},
	-- suda is a plugin to read or write files with sudo command.
	"lambdalisue/vim-suda",
	"andymass/vim-matchup",
	"jiangyinzuo/bd.vim",
	{
		"lervag/vimtex",
		cond = detect.has_pdflatex_executable,
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
	"voldikss/vim-floaterm",
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
	-- TODO: see https://github.com/nvim-neotest/neotest
	"vim-test/vim-test",
	{ "alepez/vim-gtest", ft = { "c", "cpp", "cuda" } },
	"simnalamburt/vim-mundo",
	"aperezdc/vim-template",
	"szw/vim-maximizer",
	"wesQ3/vim-windowswap",
	"tpope/vim-characterize",
	"tpope/vim-speeddating",
	"preservim/vimux",
	"honza/vim-snippets",
	"voldikss/vim-translator",
	{
		"mechatroner/rainbow_csv",
		ft = "csv",
	},
	"jiangyinzuo/open-gitdiff.vim",
	"andrewradev/linediff.vim",
	"tpope/vim-surround",
	"tpope/vim-eunuch",
	"AndrewRadev/splitjoin.vim",
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
	-- take place of 'airblade/vim-gitgutter',
	{
		"lewis6991/gitsigns.nvim",
		config = require("plugins_setup").gitsigns,
	},
	"tpope/vim-fugitive",
	"junegunn/gv.vim",
	-- Alternatives: https://github.com/HakonHarnes/img-clip.nvim
	"jiangyinzuo/img-paste.vim",
	"skywind3000/vim-quickui",
	"pechorin/any-jump.vim",
	{ "jupyter-vim/jupyter-vim", cmd = { "JupyterConnect" } },
	"goerz/jupytext.vim",
	{ "jpalardy/vim-slime", ft = { "python", "ocaml" } },
	{ "jiangyinzuo/vim-markdown", ft = "markdown" },
	{ "whonore/Coqtail", cond = detect.has_coqtop_executable, ft = "coq" },
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
		dir = "~/.vim/pack/my_plugins/start/duckdb.vim",
		dependencies = {
			"skywind3000/asynctasks.vim",
		},
	},

	"lambdalisue/vim-fern",
	{
		"jiangyinzuo/fern-oil.nvim",
		dependencies = {
			"lambdalisue/vim-fern",
		},
	},
	{
		"lambdalisue/fern-renderer-nerdfont.vim",
		dependencies = {
			"lambdalisue/vim-fern",
			"lambdalisue/nerdfont.vim",
		},
	},
	{
		"lambdalisue/fern-hijack.vim",
		dependencies = {
			"lambdalisue/vim-fern",
		},
	},
	{
		"LumaKernel/fern-mapping-fzf.vim",
		dependencies = {
			"lambdalisue/vim-fern",
		},
	},
	{
		"Yggdroot/LeaderF",
		build = ":LeaderfInstallCExtension",
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/leaderf.vim")
		end,
		dependencies = leaderf_dependencies,
	},
	{ "sebdah/vim-delve", cond = detect.has_go_executable, ft = "go" },
}

if vim.g.vimrc_lsp == "coc.nvim" then
	table.insert(M, {
		"SirVer/ultisnips",
	})
end
return M
