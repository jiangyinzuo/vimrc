return {
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'saadparwaiz1/cmp_luasnip',
			-- 'quangnguyen30192/cmp-nvim-ultisnips',
			'p00f/clangd_extensions.nvim',
			-- 如果cmp-omni和cmp-vimtex配置失败: 在`:CmpStatus`中显示unavailable source name
			-- 请检查:verbose set omnifunc? 是否符合预期
			'hrsh7th/cmp-omni',
			'micangl/cmp-vimtex',
		},
		config = require('nvim_cmp').nvim_cmp,
	},
	{
		'uga-rosa/cmp-dictionary',
		ft = { "tex", "bib", "markdown", "text" },
	},
	-- 'SirVer/ultisnips' is slow in Neovim.
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_snipmate").lazy_load()
		end
	},
}
