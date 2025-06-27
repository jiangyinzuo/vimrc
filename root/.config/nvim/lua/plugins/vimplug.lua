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
	-- vim-matchup的event不能设置为VeryLazy / VimEnter
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
	{ "madox2/vim-ai", event = "VeryLazy" },
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
	{ "heavenshell/vim-pydocstring", ft = "python" },
	{ "imbue-ai/jupyter_ascending.vim", ft = "python" },
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
	"norcalli/nvim-colorizer.lua",
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
	{
		"vim-test/vim-test",
		event = "VeryLazy",
	},
	{ "alepez/vim-gtest", ft = { "c", "cpp", "cuda" } },
	"simnalamburt/vim-mundo",
	"aperezdc/vim-template",
	"szw/vim-maximizer",
	"wesQ3/vim-windowswap",
	"tyru/capture.vim",
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
	-- replace "AndrewRadev/splitjoin.vim"
	{
		"Wansmer/treesj",
		keys = { "gJ" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({ use_default_keymaps = false })
			vim.keymap.set("n", "gJ", function()
				require("treesj").toggle({ split = { recursive = true } })
			end)
		end,
	},
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
		},
	},
	"tpope/vim-fugitive",
	"junegunn/gv.vim",
	-- Alternatives: https://github.com/HakonHarnes/img-clip.nvim
	"jiangyinzuo/img-paste.vim",
	"skywind3000/vim-quickui",
	"pechorin/any-jump.vim",
	{ "jupyter-vim/jupyter-vim", ft = { "python" } },
	{ "jpalardy/vim-slime", ft = { "lua", "python", "ocaml" } },
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
	{
		"SirVer/ultisnips",
		cond = vim.g.vimrc_lsp == "coc.nvim",
	},
}

return M
