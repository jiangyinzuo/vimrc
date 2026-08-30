if not require("config").load_plugin.ai_public then
	return {}
end

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
			debug = false, -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
	{
		"github/copilot.vim",
		cond = vim.g.ai_suggestion == "copilot.vim" or vim.g.ai_suggestion == "sidekick.nvim",
		init = function()
			vim.api.nvim_command("source ~/.vim/vimrc.d/copilot.vim")
		end,
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
		"Exafunction/windsurf.vim",
		cond = vim.g.ai_suggestion == "windsurf.vim",
		event = "BufEnter",
	},
	{ "augmentcode/augment.vim", cond = vim.g.ai_suggestion == "augment.vim" },
	{
		"jiangyinzuo/codebase-semantic-search",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	-- development
	-- {
	-- 	dir = "~/codebase-semantic-search"
	-- }
}
