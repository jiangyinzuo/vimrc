-- Linux: ~/.local/share/nvim/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- https://gist.github.com/BlueDrink9/474b150c44d41b80934990c0acfb00be
require("lazy").setup("plugins", {
	root = vim.g.vim_plug_dir,
	performance = {
		-- allow packadd <package name> in .project.vim
		reset_packpath = false,
		rtp = {
			paths = {
				"~/.vim",
				"~/.vim/after",
			},
		},
	},
})

local function setup_lualine()
	local lualine_b = {}
	local lualine_c = {}
	local winbar = {}
	if vim.g.vimrc_lsp == "nvim-lsp" then
		lualine_b = { "branch" }
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
		lualine_b = { "branch" }
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
end

local function config_clipboard()
	if vim.fn.has('wsl') == 1 then
		-- clip.exe会导致中文乱码，使用默认的wl-copy
		-- See: ~/vimrc/wsl/README.md
		-- vim.g.clipboard = {
		-- 	name = 'WslClipboard',
		-- 	copy = { ['+'] = 'clip.exe', ['*'] = 'clip.exe', },
		-- 	paste = {
		-- 		['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		-- 		['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		-- 	},
		-- 	['cache_enabled'] = 0,
		-- }
	else
		vim.g.clipboard = {
			name = 'OSC 52',
			copy = {
				['+'] = require('vim.ui.clipboard.osc52').copy('+'),
				['*'] = require('vim.ui.clipboard.osc52').copy('*'),
			},
			paste = {
				['+'] = require('vim.ui.clipboard.osc52').paste('+'),
				['*'] = require('vim.ui.clipboard.osc52').paste('*'),
			},
		}
	end
end

-- lazy.nvim has reset packpath, so we need to add ~/.vim back
--
-- make winbar background transparent
-- Reset coc.nvim highlight after colorscheme loaded
-- See: https://github.com/neoclide/coc.nvim/issues/4857
vim.cmd([[
set packpath+=~/.vim
set termguicolors
hi WinBar guibg=NONE
hi! link CocInlayHint LspInlayHint
hi link QuickPreview Normal
]])
setup_lualine()
config_clipboard()
