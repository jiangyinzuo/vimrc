if not require("config").load_plugin.ai_local then
	return {}
end

return {
	-- https://github.com/magicalne/nvim.ai
	{
		"olimorris/codecompanion.nvim",
		cond = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/codecompanion-history.nvim",
		},
		opts = {
			log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
			adapters = {
				acp = {},
				http = {
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
							--- NOTE: do not use acp adapter
							adapter = "my_openai", -- "copilot"
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
		cond = false,
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
			-- provider = "claude-code",
			auto_suggestions_provider = vim.g.avante_auto_suggestions_provider,
			acp_providers = {
				["gemini-cli"] = {
					command = "gemini",
					args = { "--experimental-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
					},
				},
				["claude-code"] = {
					-- Use https://github.com/zed-industries/claude-code-acp
					-- Alternatively, you can use https://github.com/Xuanwo/acp-claude-code
					command = "claude-code-acp",
					env = {
						NODE_NO_WARNINGS = "1",
						ANTHROPIC_BASE_URL = os.getenv("ANTHROPIC_BASE_URL"),
						ANTHROPIC_AUTH_TOKEN = os.getenv("ANTHROPIC_AUTH_TOKEN"),
						ANTHROPIC_MODEL = os.getenv("ANTHROPIC_MODEL"),
						ANTHROPIC_SMALL_FAST_MODEL = os.getenv("ANTHROPIC_SMALL_FAST_MODEL"),
					},
				},
			},
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
			selection = {
				enabled = true,
				hint_display = "none",
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
		"huggingface/llm.nvim",
		cond = vim.g.ai_suggestion == "llm.nvim",
	},
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
		cond = false and vim.fn.executable("claude") == 1,
		lazy = true,
		keys = {
			{ "<leader>ccc", "<cmd>ClaudeCode<cr>", desc = "ClaudeCode toggle" },
			{ "<leader>ccd", nil, desc = "ClaudeCode Diff" },
			{ "<leader>ccda", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
			{ "<leader>ccdd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
			{ "<leader>ccs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>ccs",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file to Claude",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
			},
		},
	},
	{
		"pittcat/claude-fzf.nvim",
		cond = false,
		dependencies = {
			"ibhagwan/fzf-lua",
			"coder/claudecode.nvim",
		},
		opts = {
			auto_context = true,
			batch_size = 10,
			-- Logging configuration
			logging = {
				level = "WARN", -- TRACE, DEBUG, INFO, WARN, ERROR
				file_logging = true, -- Enable file logging
				console_logging = false, -- Enable console logging
				show_caller = true, -- Show caller location
				timestamp = true, -- Show timestamps
			},
		},
		cmd = {
			"ClaudeFzf",
			"ClaudeFzfFiles",
			"ClaudeFzfGrep",
			"ClaudeFzfBuffers",
			"ClaudeFzfGitFiles",
			"ClaudeFzfDirectory",
		},
		keys = {
			{ "<leader>ccff", "<cmd>ClaudeFzfFiles<cr>", desc = "Claude: Add files" },
			{ "<leader>ccrg", "<cmd>ClaudeFzfGrep<cr>", desc = "Claude: Search and add" },
			{ "<leader>ccb", "<cmd>ClaudeFzfBuffers<cr>", desc = "Claude: Add buffers" },
			{ "<leader>ccgf", "<cmd>ClaudeFzfGitFiles<cr>", desc = "Claude: Add Git files" },
			{ "<leader>ccfd", "<cmd>ClaudeFzfDirectory<cr>", desc = "Claude: Add directory files" },
		},
	},
	-- Alternatives:
	-- https://github.com/jackMort/ChatGPT.nvim
	-- https://github.com/dpayne/CodeGPT.nvim
	-- https://github.com/Robitx/gp.nvim
	{ "madox2/vim-ai", event = "VeryLazy", cond = vim.fn.has("python3") == 1 },
	{
		"folke/sidekick.nvim",
		opts = {
			nes = {
				enabled = vim.g.ai_suggestion == "sidekick.nvim" and require("config").load_plugin.ai_public,
			},
			cli = {
				prompts = {
					this = "{this}",
				},
				mux = {
					enabled = true,
					create = "split",
				},
				tools = {
					hac = { cmd = { "hac" } },
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
		"leonardcser/cursortab.nvim",
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
