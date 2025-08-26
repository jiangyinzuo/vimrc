return {
	{
		"micangl/cmp-vimtex",
		lazy = true,
		event = "VeryLazy",
		cond = require("detect").has_pdflatex_executable,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			-- "hrsh7th/cmp-path",
			"sutt0n/cmp-async-path",
			"hrsh7th/cmp-cmdline",
			-- "saadparwaiz1/cmp_luasnip",
			-- 'quangnguyen30192/cmp-nvim-ultisnips',
			"p00f/clangd_extensions.nvim",
			-- 如果cmp-omni和cmp-vimtex配置失败: 在`:CmpStatus`中显示unavailable source name
			-- 请检查:verbose set omnifunc? 是否符合预期
			"garymjr/nvim-snippets",
			"hrsh7th/cmp-omni",
		},
		config = require("nvim_cmp").nvim_cmp,
	},
	{
		"uga-rosa/cmp-dictionary",
		lazy = true,
		event = "VeryLazy",
		ft = { "tex", "bib", "markdown", "text" },
	},
	-- 'SirVer/ultisnips' is slow in Neovim.
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	-- follow latest release.
	-- 	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- 	-- install jsregexp (optional!).
	-- 	build = "make install_jsregexp",
	-- 	config = function()
	-- 		require("luasnip.loaders.from_snipmate").lazy_load()
	-- 	end,
	-- },
	{
		"garymjr/nvim-snippets",
		event = "VeryLazy",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			friendly_snippets = true,
		},
	},
}
