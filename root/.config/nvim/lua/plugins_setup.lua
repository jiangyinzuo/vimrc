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
	}
end

function M.telescope()
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	vim.keymap.set('n', '<leader>rg', builtin.grep_string, {})
	vim.keymap.set('x', '<leader>rg', builtin.grep_string, {})
	vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
	vim.keymap.set('n', '<leader>fh', builtin.oldfiles, {})
	vim.api.nvim_set_keymap(
		"n",
		"<leader>ft",
		":Telescope file_browser<cr>",
		{ noremap = true }
	)

	local fb_actions = require "telescope._extensions.file_browser.actions"
	local telescope = require("telescope")
	telescope.setup({
		extensions = {
			media_files = {
				-- filetypes whitelist
				-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
				filetypes = { "png", "webp", "jpg", "jpeg" },
				-- find command (defaults to `fd`)
				find_cmd = "fd"
			},
			file_browser = {
				hijack_netrw = false,
				depth = false,
				mappings = {
					["i"] = {
						["<A-c>"] = fb_actions.create,
						["<A-e>"] = fb_actions.create_from_prompt, -- 创建文件（夹）
						["<A-r>"] = fb_actions.rename,
						["<A-m>"] = fb_actions.move,
						["<A-y>"] = fb_actions.copy,
						["<A-d>"] = fb_actions.remove,
						["<C-o>"] = fb_actions.open,
						["<C-g>"] = fb_actions.goto_parent_dir,
						["<C-e>"] = fb_actions.goto_home_dir,
						["<C-w>"] = fb_actions.goto_cwd,
						["<C-t>"] = fb_actions.change_cwd,
						["<C-f>"] = fb_actions.toggle_browser,
						["<C-h>"] = fb_actions.toggle_hidden,
						["<C-s>"] = fb_actions.toggle_all,
					},
				}
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

	telescope.load_extension "file_browser"
	telescope.load_extension "media_files"
	telescope.load_extension "fzf"
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
			lualine_a = { 'filename' },
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
			lualine_c = { 'filename' },
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
		sign_priority = 10,
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

function M.colorscheme()
	-- make winbar background transparent
	vim.cmd([[
	set termguicolors
	colorscheme solarized
	hi WinBar guibg=NONE
	]])
end

return M
