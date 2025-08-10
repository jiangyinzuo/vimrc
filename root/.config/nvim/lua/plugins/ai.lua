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
	-- https://github.com/magicalne/nvim.ai
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
			adapters = {
				opts = {
					show_defaults = false,
				},
				my_anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						url = vim.g.claude_endpoint .. "/v1/messages",
						env = {
							api_key = "ANTHROPIC_API_KEY",
						},
						schema = {
							model = {
								default = vim.g.claude_model,
							},
						},
					})
				end,
				my_openai = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = vim.g.openai_endpoint, -- optional: default value is ollama url http://127.0.0.1:11434
							chat_url = "/chat/completions",
							api_key = "OPENAI_API_KEY", -- optional: if your endpoint is authenticated
						},
						schema = {
							model = {
								default = vim.g.openai_model, -- define llm model to be used
							},
						},
					})
				end,
			},
			strategies = {
				-- codecompanion.nvim暂时没使用native tools
				-- https://github.com/olimorris/codecompanion.nvim/discussions/494
				chat = {
					adapter = "my_openai",
				},
				inline = {
					adapter = "my_openai",
				},
				cmd = {
					adapter = "my_openai",
				},
				workflow = {
					adapter = "my_openai",
				},
			},
		},
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
		"milanglacier/minuet-ai.nvim",
		config = function()
			require("minuet").setup({
				cmp = {
					enable_auto_complete = false,
				},
				blink = {
					enable_auto_complete = false,
				},
				virtualtext = {
					auto_trigger_ft = { "*" },
					keymap = {
						-- accept whole completion
						accept = "<Tab>",
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
			})
		end,
		cond = vim.g.ai_suggestion == "minuet-ai.nvim",
	},
	{
		"dlants/magenta.nvim",
		lazy = false, -- you could also bind to <leader>mt
		cond = vim.g.ai_suggestion == "magenta.nvim",
		build = "npm install --frozen-lockfile",
		opts = {
			profiles = {
				{
					name = "claude-3-7",
					provider = "anthropic",
					model = "claude-3-7-sonnet-latest",
					fastModel = "claude-3-5-haiku-latest", -- optional, defaults provided
					apiKeyEnvVar = "ANTHROPIC_API_KEY",
					baseUrl = vim.g.claude_endpoint,
				},
			},
			editPrediction = {
				-- Use a dedicated profile for predictions (independent of main profiles)
				profile = {
					provider = "anthropic",
					model = "claude-4-sonnet-latest",
					apiKeyEnvVar = "ANTHROPIC_API_KEY",
					baseUrl = vim.g.claude_endpoint,
				},

				-- Maximum number of changes to track for context (default: 10)
				changeTrackerMaxChanges = 20,

				-- Token budget for including recent changes (default: 1000)
				-- Higher values include more history but use more tokens
				recentChangeTokenBudget = 1500,

				-- Replace the default system prompt entirely
				-- systemPrompt = "Your custom prediction system prompt here...",

				-- Append to the default system prompt instead of replacing it
				-- systemPromptAppend = "Additional instructions to improve predictions...",
			},
		},
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		-- comment the following line to ensure hub will be ready at the earliest
		cmd = "MCPHub", -- lazy load by default
		build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
		-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
		-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
		config = function()
			require("mcphub").setup()
		end,
	},
	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			debug = false,
			provider = vim.g.avante_provider,
			auto_suggestions_provider = vim.g.avante_auto_suggestions_provider,
			providers = {
				openai = {
					endpoint = vim.g.openai_endpoint,
					model = vim.g.openai_model,
					timeout = 30000, -- Timeout in milliseconds
					extra_request_body = {
						options = {
							temperature = 0,
							max_tokens = 4096,
						},
					},
					disable_tools = vim.g.openai_disable_tools == 1,
				},
				claude = {
					endpoint = vim.g.claude_endpoint,
					model = vim.g.claude_model,
					extra_request_body = {
						options = {
							temperature = 0,
							max_tokens = 4096,
						},
					},
					disable_tools = false,
				},
				moonshot = {
					endpoint = "https://api.moonshot.ai/v1",
					model = "kimi-k2-0711-preview",
					timeout = 30000, -- Timeout in milliseconds
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 32768,
					},
				},
				vllm = {
					__inherited_from = "openai",
					endpoint = vim.g.vllm_endpoint,
					model = vim.g.vllm_model,
					disable_tools = vim.g.vllm_disable_tools == 1,
				},
			},
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
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"MeanderingProgrammer/render-markdown.nvim",
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
		"huggingface/llm.nvim",
		cond = vim.g.ai_suggestion == "llm.nvim",
	},
	-- {
	-- 	"aweis89/ai-terminals.nvim",
	-- 	dependencies = { "folke/snacks.nvim" },
	-- 	config = function()
	-- 		require("ai-terminals").setup({})
	-- 	end,
	-- },
	-- {
	-- goose.nvim只支持对整个项目查看diff，不支持对某个修改查看diff并决定是否接受
	{
		"azorng/goose.nvim",
		cond = false,
		config = function()
			require("goose").setup({
				default_global_keymaps = false,
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
		},
	},
	-- 无法滚动，查看前面的对话记录
	-- 无法查看diff并决定是否接受
	{
		"NickvanDyke/opencode.nvim",
		cond = false,
		dependencies = { 'folke/snacks.nvim', },
	}
}
