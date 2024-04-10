local M = {}
function M.nvim_treesitter()
	require("nvim-treesitter.configs").setup {
		-- 安装 language parser
		-- :TSInstallInfo 命令查看支持的语言
		ensure_installed = { "cpp", "lua", "vim", "vimdoc", "python", "rust", "html" },
		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,
		-- 启用代码高亮模块
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		endwise = {
			enable = true,
		},
	}
end

function M.telescope()
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	vim.keymap.set('n', '<leader>rg', builtin.grep_string, {})
	vim.keymap.set('x', '<leader>rg', builtin.grep_string, {})
	vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
	vim.keymap.set('n', '<leader>fh', builtin.oldfiles, {})

	local telescope = require("telescope")
	telescope.setup({
		extensions = {
			advanced_git_search = {
				-- See Config
				git_flags = { "-c", "delta.pager=never" }
			},
			media_files = {
				-- filetypes whitelist
				-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
				filetypes = { "png", "webp", "jpg", "jpeg" },
				-- find command (defaults to `fd`)
				find_cmd = "fd"
			},
			fzf = {
				fuzzy = true,               -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case",   -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			}
		}
	})

	telescope.load_extension "media_files"
	telescope.load_extension "fzf"
	telescope.load_extension "advanced_git_search"
	telescope.load_extension "session-lens"
end

function M.mason()
	require("mason").setup {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		github = {
			-- The template URL to use when downloading assets from GitHub.
			-- The placeholders are the following (in order):
			-- 1. The repository (e.g. "rust-lang/rust-analyzer")
			-- 2. The release version (e.g. "v0.3.0")
			-- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
			download_url_template = "https://cors.isteed.cc/github.com/%s/releases/download/%s/%s",
		},
	}
end

function M.lualine()
	local lualine_c = {}
	local winbar    = {}
	if vim.g.vimrc_lsp == 'nvim-lsp' then
		lualine_c = {
			-- invoke `progress` to get lsp progress status.
			require("lsp-progress").progress,
		}
		winbar = {
			lualine_c = {
				"navic",
				color_correction = nil,
				navic_opts = nil
			}
		}
	elseif vim.g.vimrc_lsp == 'coc.nvim' then
		lualine_c = {
			-- invoke `coc#status` to get coc status.
			'coc#status',
		}
		winbar = {
			lualine_c = {
				[[%{%get(b:, 'coc_symbol_line', '')%}]]
			}
		}
	end

	local filename = {
		'filename',
		path = 4,
		shorting_target = 40,
	}
	require('lualine').setup {
		options = {
			icons_enabled = true,
			-- theme = 'solarized',
			component_separators = { left = '', right = '' },
			-- leave them blank, or lualine will kill intro.
			-- https://github.com/nvim-lualine/lualine.nvim/issues/259#issuecomment-1890485361
			section_separators = { left = '', right = '' },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = false,
			refresh = {
				statusline = 1200,
				tabline = 1000,
				winbar = 1200,
			}
		},
		sections = {
			lualine_a = { filename },
			-- 'diff' is slow
			lualine_b = { 'branch', 'diagnostics' },
			lualine_c = lualine_c,
			lualine_x = { 'encoding', 'fileformat', 'filetype' },
			lualine_y = { 'progress' },
			lualine_z = { 'location' }
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { filename },
			lualine_x = { 'location' },
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		winbar = winbar,
		inactive_winbar = {},
		extensions = { 'quickfix' }
	}
end

function M.gitsigns()
	require('gitsigns').setup {
		-- 比默认priority低1级, bookmarkspriority为10
		sign_priority = 9,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map('n', ']c', function()
				if vim.wo.diff then return ']c' end
				vim.schedule(function() gs.next_hunk() end)
				return '<Ignore>'
			end, { expr = true })

			map('n', '[c', function()
				if vim.wo.diff then return '[c' end
				vim.schedule(function() gs.prev_hunk() end)
				return '<Ignore>'
			end, { expr = true })

			-- Text object
			map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
		end
	}
end

function M.auto_session()
	local opts = {
		log_level = 'error',
		auto_session_enable_last_session = false,
		auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
		auto_session_enabled = true,
		auto_save_enabled = nil,
		auto_restore_enabled = nil,
		auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "~/.config", "~/.vim", "~/vimrc" },
		auto_session_use_git_branch = nil,
		-- the configs below are lua only
		bypass_session_save_file_types = nil
	}

	require('auto-session').setup(opts)
end

local colorscheme_loaded = false
function M.colorscheme()
	if not colorscheme_loaded then
		-- make winbar background transparent
		vim.cmd([[
			set termguicolors
			colorscheme solarized
			hi WinBar guibg=NONE
		]])
		M.lualine()
		colorscheme_loaded = true
	end
end

function M.vimrc_load_colorscheme()
	if vim.g.vimrc_load_colorscheme == nil or vim.g.vimrc_load_colorscheme then
		M.colorscheme()
	end
end

return M
