local plugins_setup = require('plugins_setup')

local ai_complete
if vim.g.ai_complete == 'codeium' then
	ai_complete = 'Exafunction/codeium.vim'
else
	ai_complete = {
		"CopilotC-Nvim/CopilotChat.nvim",
		lazy = true,
		branch = "canary",
		dependencies = {
			{ "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		cmd = {
			"CopilotChat",
			"CopilotChatFix",
			"CopilotChatDocs",
			"CopilotChatLoad",
			"CopilotChatOpen",
			"CopilotChatSave",
			"CopilotChatClose",
			"CopilotChatReset",
			"CopilotChatTests",
			"CopilotChatCommit",
			"CopilotChatToggle",
			"CopilotChatExplain",
			"CopilotChatOptimize",
			"CopilotChatDebugInfo",
			"CopilotChatCommitStaged",
			"CopilotChatFixDiagnostic",
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
	}
end
return {
	{
		"ishan9299/nvim-solarized-lua",
		lazy = false,  -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
	},
	{
		'nvim-tree/nvim-web-devicons'
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = plugins_setup.nvim_treesitter,
	},
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
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = plugins_setup.telescope,
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{
		"williamboman/mason.nvim",
		config = plugins_setup.mason,
	},
	ai_complete,
	{
		'sindrets/diffview.nvim',
	},
	{
		"luckasRanarison/nvim-devdocs",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = {
			"DevdocsOpen",
			"DevdocsFetch",
			"DevdocsToggle",
			"DevdocsUpdate",
			"DevdocsInstall",
			"DevdocsOpenFloat",
			"DevdocsUninstall",
			"DevdocsUpdateAll",
			"DevdocsKeywordprg",
			"DevdocsOpenCurrent",
			"DevdocsOpenCurrentFloat",
		},
		opts = {}
	},
	{
		'numToStr/Comment.nvim',
		opts = {
		}
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
		}
	},
}
