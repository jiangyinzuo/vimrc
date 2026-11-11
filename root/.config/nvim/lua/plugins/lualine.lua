local lualine = {
	"nvim-lualine/lualine.nvim",
	-- 首帧前完成 tabline 初始化，避免 UIEnter 后增行和换色。
	lazy = false,
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
		lualine_c = {
			"diagnostics",
			-- invoke `progress` to get lsp progress status.
			require("lsp-progress").progress,
		}
		winbar = {
			lualine_c = {
				"navic_note",
			},
		}

		local identity = vim.uv.os_get_passwd().username .. "@" .. vim.fn.hostname()
		-- 预先创建配色表，重绘时只按背景模式选择，避免反复分配。
		local function solarized_color(fg)
			local colors = {
				dark = { fg = fg, bg = "#073642", gui = "NONE" },
				light = { fg = fg, bg = "#eee8d5", gui = "NONE" },
			}
			return function()
				return colors[vim.o.background]
			end
		end

		local function tabs_width()
			return math.max(1, vim.o.columns - vim.fn.strdisplaywidth(identity) - vim.fn.strdisplaywidth(vim.fn.getcwd()) - 4)
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
						"neo-tree",
					},
					statusline = {
						"Avante",
						"AvanteSelectedFiles",
						"AvanteInput",
						"neo-tree",
					},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				always_show_tabline = true,
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
			tabline = {
				lualine_a = {
					{
						function()
							return identity
						end,
						color = solarized_color("#2aa198"),
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						"tabs",
						mode = 1,
						-- 用满两侧信息之间的空间，不再限制为窗口宽度的 1/3。
						max_length = tabs_width,
						fmt = function(name)
							-- 仅在剩余空间不足时缩短名称，保留文件名尾部。
							name = name:gsub("%%%%", "%%")
							local max_width = math.max(1, tabs_width() - 2)
							if vim.fn.strdisplaywidth(name) > max_width then
								name = vim.fn.strcharpart(name, math.max(0, vim.fn.strchars(name) - max_width + 1))
								while vim.fn.strdisplaywidth(name) > max_width - 1 do
									name = vim.fn.strcharpart(name, 1)
								end
								name = "…" .. name
							end
							return (name:gsub("%%", "%%%%"))
						end,
						tabs_color = {
							active = { gui = "bold" },
							inactive = solarized_color("#839496"),
						},
					},
				},
				-- 与 :pwd 一致，包含窗口和标签页的局部工作目录。
				lualine_z = {
					{
						function()
							return vim.fn.getcwd()
						end,
						color = solarized_color("#268bd2"),
					},
				},
			},
			winbar = winbar,
			inactive_winbar = {},
			extensions = { "fern", "quickfix", "nvim-dap-ui" },
		})
		require("lualine").refresh({ force = true })
	end,
}

-- WARN: DO NOT USE AndreM222/copilot-lualine

table.insert(lualine.dependencies, "neovim/nvim-lspconfig")
table.insert(lualine.dependencies, "linrongbin16/lsp-progress.nvim")

return lualine
