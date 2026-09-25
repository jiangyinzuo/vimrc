if not require("config").load_plugin.ai_local then
	return {}
end

return {
	{
		"milanglacier/minuet-ai.nvim",
		config = function()
			local default_opt = {
				cmp = {
					enable_auto_complete = true,
				},
				blink = {
					enable_auto_complete = false,
				},
				virtualtext = {
					auto_trigger_ft = { "*" },
					keymap = {
						-- minuet-ai.nvim无法fallback tab键
						-- accept whole completion
						-- Do not map here, see nvim-cmp configuration
						accept = nil,
						-- accept one line
						accept_line = "<M-l>",
						-- accept n lines (prompts for number)
						-- e.g. "A-z 2 CR" will accept 2 lines
						accept_n_lines = "<A-z>",
						-- Cycle to prev completion item, or manually invoke completion
						prev = "<A-[>",
						-- Cycle to next completion item, or manually invoke completion
						next = "<A-]>",
						dismiss = "<A-e>",
					},
				},
				provider = "openai_fim_compatible",
				provider_options = {
					openai_fim_compatible = {
						api_key = "DEEPSEEK_API_KEY",
						name = "deepseek",
						optional = {
							max_tokens = 256,
							top_p = 0.9,
						},
					},
				},
			}
			local merged = vim.tbl_extend("force", default_opt, require("config").minuet_opt)
			require("minuet").setup(merged)
		end,
		cond = vim.g.ai_suggestion == "minuet-ai.nvim",
	},
	{
		"huggingface/llm.nvim",
		cond = vim.g.ai_suggestion == "llm.nvim",
	},
	-- 需要连接huggingface，可能报错
	-- 使用不擅长处理代码的embedding模型，会导致vector search不是很准
	-- {
	-- 	"Davidyz/VectorCode",
	-- 	version = "*",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- cond = vim.fn.executable("vectorcode") == 1,
	-- },
	{
		"folke/sidekick.nvim",
		cond = true,
		opts = {
			nes = {
				enabled = vim.g.ai_suggestion == "sidekick.nvim" and require("config").load_plugin.ai_public,
			},
			cli = {
				prompts = {
					this = "{this}",
					diagnostics = "{file}\n{diagnostics}",
				},
				mux = {
					enabled = true,
					create = "split",
				},
				tools = {
					omp = { cmd = { "omp" } },
				},
			},
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
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Sidekick send This",
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
		"cursortab/cursortab.nvim",
		cond = vim.g.has_go_executable ~= 0 and vim.g.ai_suggestion == "cursortab.nvim",
		build = "cd server && go build",
		config = function()
			require("cursortab").setup({
				provider = {
					-- https://huggingface.co/sweepai/sweep-next-edit-1.5B
					-- https://blog.sweep.dev/posts/oss-next-edit
					type = "sweep",
					url = "http://localhost:8000",
					model = "sweep-next-edit-1.5b",
				},
			})
		end,
	},
}
