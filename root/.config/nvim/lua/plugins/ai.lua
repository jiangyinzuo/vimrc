local ai_complete = {}
if vim.g.ai_complete == "codeium" then
	ai_complete = { "Exafunction/codeium.vim", event = "BufEnter" }
elseif vim.g.ai_complete == "copilot" then
	ai_complete = {
		{
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
		},
		"github/copilot.vim",
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
