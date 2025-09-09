if require("config").load_plugin.ai_public == false then
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
		"github/copilot.vim",
		cond = vim.g.ai_suggestion == "copilot.vim",
	},
	{
		"copilotlsp-nvim/copilot-lsp",
		-- cond = vim.g.ai_suggestion == "copilot.vim",
		cond = false,
		init = function()
			vim.g.copilot_nes_debounce = 500
			vim.lsp.enable("copilot_ls")
			vim.keymap.set("n", "<tab>", function()
				-- Try to jump to the start of the suggestion edit.
				-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
				local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
					or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
			end)
			-- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
			vim.keymap.set("n", "<esc>", function()
				if not require("copilot-lsp.nes").clear() then
					-- fallback to other functionality
				end
			end, { desc = "Clear Copilot suggestion or fallback" })
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
