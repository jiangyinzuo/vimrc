local lualine = {
	"nvim-lualine/lualine.nvim",
	event = "UIEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	priority = 1,
	config = function()
		local lualine_b = { "branch" }
		local lualine_c = {}
		local winbar = {}
		if vim.g.ai_suggestion == "sidekick.nvim" then
			table.insert(lualine_b, {
				function()
					return " "
				end,
				color = function()
					local status = require("sidekick.status").get()
					if status then
						return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
					end
				end,
				cond = function()
					local status = require("sidekick.status")
					return status.get() ~= nil
				end,
			})
		end
		if vim.g.vimrc_lsp == "nvim-lsp" then
			lualine_c = {
				"diagnostics",
				-- invoke `progress` to get lsp progress status.
				require("lsp-progress").progress,
			}
			winbar = {
				lualine_c = {
					"navic",
					color_correction = nil,
					navic_opts = nil,
				},
			}
		elseif vim.g.vimrc_lsp == "coc.nvim" then
			lualine_c = {
				-- invoke `coc#status` to get coc status.
				[[%{exists("*coc#status")?coc#status():''}]],
			}
			winbar = {
				lualine_c = {
					[[%{%get(b:, 'coc_symbol_line', '')%}]],
				},
			}
		end

		local filename = {
			"filename",
			path = 4,
			shorting_target = 40,
		}
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				-- leave them blank, or lualine will kill intro.
				-- https://github.com/nvim-lualine/lualine.nvim/issues/259#issuecomment-1890485361
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					winbar = {
						-- do not override dapui's buttons
						"dap-repl",
						"dapui_breakpoints",
						"dapui_console",
						"dapui_scopes",
						"dapui_watches",
						"dapui_stacks",
						"termdebug",
						"Avante",
						"AvanteSelectedFiles",
						"AvanteInput",
						"oil",
					},
					statusline = {
						"Avante",
						"AvanteSelectedFiles",
						"AvanteInput",
					}
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1200,
					tabline = 1000,
					winbar = 1200,
				},
			},
			sections = {
				lualine_a = { filename },
				-- 'diff' is slow
				lualine_b = lualine_b,
				lualine_c = lualine_c,
				lualine_x = {},
				lualine_y = {},
				-- file location
				lualine_z = { "%l/%L:%v", { "filetype", icons_enabled = false }, "encoding", "fileformat" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { filename },
				-- file location
				lualine_x = { "%l/%L:%v" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = winbar,
			inactive_winbar = {},
			extensions = { "fern", "quickfix", "nvim-dap-ui" },
		})
	end,
}

-- WARN: DO NOT USE AndreM222/copilot-lualine

if vim.g.vimrc_lsp == "nvim-lsp" then
	table.insert(lualine.dependencies, "neovim/nvim-lspconfig")
	table.insert(lualine.dependencies, "linrongbin16/lsp-progress.nvim")
else
	table.insert(lualine.dependencies, "neoclide/coc.nvim")
end

return lualine
