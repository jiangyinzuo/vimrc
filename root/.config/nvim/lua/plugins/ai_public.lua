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
		-- See ~/.vim/vimrc.d/ai.vim
		"github/copilot.vim",
		cond = vim.g.ai_suggestion == "copilot.vim" or vim.g.ai_suggestion == "sidekick.nvim",
	},
	{
		"folke/sidekick.nvim",
		opts = {
			nes = {
				enabled = vim.g.ai_suggestion == "sidekick.nvim",
			},
			cli = {
				prompts = {
					this = "{this}"
				}
			}
		},
		cmd = { "Sidekick" },
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if require("sidekick").nes_jump_or_apply() then
						return -- jumped or applied
					end

					-- if you are using Neovim's native inline completions
					if vim.lsp.inline_completion.get() then
						return
					end

					-- any other things (like snippets) you want to do on <tab> go here.

					-- fall back to normal tab
					return "<tab>"
				end,
				mode = { "i", "n" },
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ focus = true })
				end,
				desc = "Sidekick Toggle CLI",
				mode = { "n", "v" },
			},
			-- {
			-- 	"<leader>ac",
			-- 	function()
			-- 		-- Same as above, but opens Claude directly
			-- 		require("sidekick.cli").toggle({ name = "claude", focus = true })
			-- 	end,
			-- 	desc = "Sidekick Claude Toggle",
			-- },
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
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
