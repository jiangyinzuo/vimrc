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

-- local explore_codebase_description = "Explore codebase via command line tools"
-- local function explore_codebase_prompt(tool_name)
-- 	return string.format(
-- 		[[In order to better explore the codebase, you should wisely use various command line tools via the `%s` tool, just like a senior programmer.
-- NOTE that some modern command-line tools like `ripgrep`, `fd`, `ugrep` and `fzf` are available in the system, you should wisely use them to explore the codebase.
-- ]],
-- 		tool_name
-- 	)
-- end

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
			"ravitemer/codecompanion-history.nvim",
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
			extensions = {
				-- mcphub = {
				-- 	callback = "mcphub.extensions.codecompanion",
				-- 	opts = {
				-- 		-- MCP Tools
				-- 		make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
				-- 		show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
				-- 		add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
				-- 		show_result_in_chat = true, -- Show tool results directly in chat buffer
				-- 		format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
				-- 		-- MCP Resources
				-- 		make_vars = true, -- Convert MCP resources to #variables for prompts
				-- 		-- MCP Prompts
				-- 		make_slash_commands = true, -- Add MCP prompts as /slash commands
				-- 	},
				-- },
				history = {
					enabled = true,
					opts = {
						-- Keymap to open history from chat buffer (default: gh)
						keymap = "gh",
						-- Keymap to save the current chat manually (when auto_save is disabled)
						save_chat_keymap = "sc",
						-- Save all chats by default (disable to save only manually using 'sc')
						auto_save = true,
						-- Number of days after which chats are automatically deleted (0 to disable)
						expiration_days = 0,
						-- Picker interface (auto resolved to a valid picker)
						picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
						---Optional filter function to control which chats are shown when browsing
						chat_filter = nil, -- function(chat_data) return boolean end
						-- Customize picker keymaps (optional)
						picker_keymaps = {
							rename = { n = "r", i = "<M-r>" },
							delete = { n = "d", i = "<M-d>" },
							duplicate = { n = "<C-y>", i = "<C-y>" },
						},
						---Automatically generate titles for new chats
						auto_generate_title = true,
						title_generation_opts = {
							---Adapter for generating titles (defaults to current chat adapter)
							adapter = nil, -- "copilot"
							---Model for generating titles (defaults to current chat model)
							model = nil, -- "gpt-4o"
							---Number of user prompts after which to refresh the title (0 to disable)
							refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
							---Maximum number of times to refresh the title (default: 3)
							max_refreshes = 3,
							format_title = function(original_title)
								-- this can be a custom function that applies some custom
								-- formatting to the title.
								return original_title
							end,
						},
						---On exiting and entering neovim, loads the last chat on opening chat
						continue_last_chat = false,
						---When chat is cleared with `gx` delete the chat from history
						delete_on_clearing_chat = false,
						---Directory path to save the chats
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
						---Enable detailed logging for history extension
						enable_logging = false,

						-- Summary system
						summary = {
							-- Keymap to generate summary for current chat (default: "gcs")
							create_summary_keymap = "gcs",
							-- Keymap to browse summaries (default: "gbs")
							browse_summaries_keymap = "gbs",

							generation_opts = {
								adapter = nil, -- defaults to current chat adapter
								model = nil, -- defaults to current chat model
								context_size = 90000, -- max tokens that the model supports
								include_references = true, -- include slash command content
								include_tool_outputs = true, -- include tool execution results
								system_prompt = nil, -- custom system prompt (string or function)
								format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
							},
						},
					},
				},
			},
			prompt_library = {
				-- ["Explore codebase"] = {
				-- 	strategy = "chat",
				-- 	description = explore_codebase_description,
				-- 	opts = {
				-- 		index = 9,
				-- 		is_default = true,
				-- 		is_slash_cmd = true,
				-- 		short_name = "commit",
				-- 	},
				-- 	prompts = {
				-- 		{
				-- 			role = "user",
				-- 			content = explore_codebase_prompt("cmd_runner"),
				-- 		},
				-- 	},
				-- },
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
		cond = false,
		-- comment the following line to ensure hub will be ready at the earliest
		cmd = "MCPHub", -- lazy load by default
		build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
		-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
		-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
		config = function()
			require("mcphub").setup({
				extensions = {
					avante = {
						make_slash_commands = true, -- make /slash commands from MCP server prompts
					},
				},
			})
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
			-- append custom_prompt(rules) to the default system prompt
			rules = {
				project_dir = ".avante/rules", -- relative to project root, can also be an absolute path
				global_dir = "~/.config/avante/rules", -- absolute path
			},
			-- override the default prompt directory
			override_prompt_dir = vim.fn.expand("~/.config/nvim/avante_prompts"),
			-- system_prompt as function ensures LLM always has latest MCP server state
			-- This is evaluated for every message, even in existing chats
			-- system_prompt = function()
			-- 	local hub = require("mcphub").get_hub_instance()
			-- 	return hub and hub:get_active_servers_prompt() or ""
			-- end,
			-- Using function prevents requiring mcphub before it's loaded
			custom_tools = function()
				return {
					-- require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
			disabled_tools = {
				-- "list_files", -- Built-in file operations
				-- "search_files",
				-- "read_file",
				-- "create_file",
				-- "rename_file",
				-- "delete_file",
				-- "create_dir",
				-- "rename_dir",
				-- "delete_dir",
				-- "bash", -- Built-in terminal access
			},
			shortcuts = {
				-- TODO: check avante.nvim's system prompt, it bans using `grep` in bash
				-- {
				-- 	name = "explore-codebase",
				-- 	description = explore_codebase_description,
				-- 	details = "Use command line tools to explore the codebase",
				-- 	prompts = explore_codebase_prompt("bash"),
				-- },
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"MeanderingProgrammer/render-markdown.nvim",
			-- "ravitemer/mcphub.nvim",
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
		dependencies = { "folke/snacks.nvim" },
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
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		opts = {
			terminal_cmd = "claude", -- ccr code
		},
		cond = vim.fn.executable("claude") == 1,
	},
}
