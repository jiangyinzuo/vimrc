if vim.g.avante_provider == "copilot" or vim.g.avante_auto_suggestions_provider == "copilot" then
	vim.cmd(
		[[echoerr 'DO NOT USE third-party Copilot extensions!!! See: https://github.com/yetone/avante.nvim/issues/557 and https://github.com/zbirenbaum/copilot-cmp/issues/117']]
	)
	return nil
end
-- WARN: DO NOT USE
-- - copilot.lua
-- - copilot-cmp
-- - avante.nvim with copilot provider
-- See: https://support.github.com/ticket/personal/0/3165529

-- local copilot_lua = {
-- 	"zbirenbaum/copilot.lua",
-- 	event = "InsertEnter",
-- 	config = function()
-- 		require("copilot").setup({
-- 			suggestion = {
-- 				enabled = true,
-- 				auto_trigger = true,
-- 				hide_during_completion = false,
-- 				debounce = 75,
-- 				keymap = {
-- 					accept = false,
-- 					accept_word = "<M-w>",
-- 					accept_line = "<M-l>",
-- 					next = "<M-]>",
-- 					prev = "<M-[>",
-- 					dismiss = "<C-]>",
-- 				},
-- 			},
-- 		})
-- 		vim.keymap.set("i", "<Tab>", function()
-- 			if require("copilot.suggestion").is_visible() then
-- 				require("copilot.suggestion").accept()
-- 			else
-- 				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
-- 			end
-- 		end, { desc = "Super Tab" })
-- 	end,
-- }

local openai_api = {
	endpoint = vim.g.openai_endpoint,
	model = vim.g.openai_model,
	timeout = 30000, -- Timeout in milliseconds
	temperature = 0,
	max_tokens = 4096,
	disable_tools = not vim.tbl_contains({
		"deepseek-ai/DeepSeek-V3",
		"deepseek-chat",
	}, vim.g.openai_model),
}

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		lazy = true,
		cond = vim.g.ai_suggestion == "copilot.vim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		cmd = {
			"CopilotChat",
			"CopilotChatAgents",
			"CopilotChatClose",
			"CopilotChatCommit",
			"CopilotChatCommitStaged",
			"CopilotChatDebugInfo",
			"CopilotChatDocs",
			"CopilotChatExplain",
			"CopilotChatFix",
			"CopilotChatFixDiagnostic",
			"CopilotChatLoad",
			"CopilotChatModels",
			"CopilotChatOpen",
			"CopilotChatOptimize",
			"CopilotChatReset",
			"CopilotChatTests",
			"CopilotChatToggle",
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
	-- https://github.com/magicalne/nvim.ai
	-- {
	-- 	"olimorris/codecompanion.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
	-- 		"nvim-telescope/telescope.nvim", -- Optional: For working with files with slash commands
	-- 		-- {
	-- 		-- 	"stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
	-- 		-- 	opts = {},
	-- 		-- },
	-- 	},
	-- 	config = true
	-- },
	{
		"github/copilot.vim",
		cond = vim.g.ai_suggestion == "copilot.vim",
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = true,
		version = false, -- set this if you want to always pull the latest change
		opts = { -- add any opts here
			debug = false,
			provider = vim.g.avante_provider,
			auto_suggestions_provider = vim.g.avante_auto_suggestions_provider,
			openai = openai_api,
			behaviour = {
				auto_suggestions = vim.g.ai_suggestion == "avante.nvim", -- Experimental stage
			},
			mappings = {
				suggestion = {
					accept = "<Tab>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			-- {
			-- 	-- support for image pasting
			-- 	"HakonHarnes/img-clip.nvim",
			-- 	event = "VeryLazy",
			-- 	opts = {
			-- 		-- recommended settings
			-- 		default = {
			-- 			embed_image_as_base64 = false,
			-- 			prompt_for_file_name = false,
			-- 			drag_and_drop = {
			-- 				insert_mode = true,
			-- 			},
			-- 			-- required for Windows users
			-- 			use_absolute_path = true,
			-- 		},
			-- 	},
			-- },
		},
	},
	{
		"luozhiya/fittencode.nvim",
		cond = vim.g.ai_suggestion == "fittencode",
		config = function()
			require("fittencode").setup()
		end,
	},
	{
		"codota/tabnine-nvim",
		cond = vim.g.ai_suggestion == "tabnine-nvim",
		build = "./dl_binaries.sh",
	},
	{
		"Exafunction/codeium.vim",
		cond = vim.g.ai_suggestion == "codeium.vim",
		event = "BufEnter",
	},
	{
		"huggingface/llm.nvim",
		cond = vim.g.ai_suggestion == "llm.nvim",
	},
}
