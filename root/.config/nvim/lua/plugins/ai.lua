local ai_complete = {}
if vim.g.ai_complete == "codeium" then
	ai_complete = { "Exafunction/codeium.vim", event = "BufEnter" }
elseif vim.g.ai_complete == "copilot" then
	ai_complete = {
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			lazy = true,
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
		"github/copilot.vim",
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
		-- {
		-- 	"yetone/avante.nvim",
		-- 	event = "VeryLazy",
		-- 	lazy = false,
		-- 	version = false, -- set this if you want to always pull the latest change
		-- 	opts = {
		-- 		-- add any opts here
		-- 		provider = "copilot",
		-- 		behaviour = {
		-- 			auto_suggestions = true, -- Experimental stage
		-- 		},
		-- 	},
		-- 	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- 	build = "make",
		-- 	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		-- 	dependencies = {
		-- 		"stevearc/dressing.nvim",
		-- 		"nvim-lua/plenary.nvim",
		-- 		"MunifTanjim/nui.nvim",
		-- 		--- The below dependencies are optional,
		-- 		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		-- 		"zbirenbaum/copilot.lua", -- for providers='copilot'
		-- 		{
		-- 			-- support for image pasting
		-- 			"HakonHarnes/img-clip.nvim",
		-- 			event = "VeryLazy",
		-- 			opts = {
		-- 				-- recommended settings
		-- 				default = {
		-- 					embed_image_as_base64 = false,
		-- 					prompt_for_file_name = false,
		-- 					drag_and_drop = {
		-- 						insert_mode = true,
		-- 					},
		-- 					-- required for Windows users
		-- 					use_absolute_path = true,
		-- 				},
		-- 			},
		-- 		},
		-- 		{
		-- 			-- Make sure to set this up properly if you have lazy=true
		-- 			"MeanderingProgrammer/render-markdown.nvim",
		-- 			opts = {
		-- 				file_types = { "markdown", "Avante" },
		-- 			},
		-- 			ft = { "markdown", "Avante" },
		-- 		},
		-- 	},
		-- },
	}
elseif vim.g.ai_complete == "fittencode" then
	ai_complete = {
		{
			"luozhiya/fittencode.nvim",
			config = function()
				require("fittencode").setup()
			end,
		},
	}
elseif vim.g.ai_complete == "tabnine" then
	ai_complete = { "codota/tabnine-nvim", build = "./dl_binaries.sh" }
end
return ai_complete
