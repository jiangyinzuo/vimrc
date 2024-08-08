local M = {}
function M.nvim_treesitter()
	require("nvim-treesitter.configs").setup({
		-- 安装 language parser
		-- :TSInstallInfo 命令查看支持的语言
		ensure_installed = {
			"c",
			"cpp",
			"go",
			"lua",
			"vim",
			"vimdoc",
			"python",
			"rust",
			"html",
			"query",
			"markdown",
			"markdown_inline",
		},
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
		-- https://github.com/andymass/vim-matchup
		matchup = {
			enable = true, -- mandatory, false will disable the whole extension
			-- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
			-- [options]
		},
	})
end

function M.telescope()
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
	vim.keymap.set("n", "<leader>rg", builtin.grep_string, {})
	vim.keymap.set("x", "<leader>rg", builtin.grep_string, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.oldfiles, {})

	local telescope = require("telescope")
	telescope.setup({
		extensions = {
			advanced_git_search = {
				-- See Config
				git_flags = { "-c", "delta.pager=never" },
			},
			bibtex = {
				-- Depth for the *.bib file
				depth = 999,
				-- Custom format for citation label
				custom_formats = {},
				-- Format to use for citation label.
				-- Try to match the filetype by default, or use 'plain'
				format = "",
				-- Path to global bibliographies (placed outside of the project)
				global_files = {},
				-- Define the search keys to use in the picker
				search_keys = { "year", "title" },
				-- Template for the formatted citation
				citation_format = "{{author}} ({{year}}), {{title}}.",
				-- Only use initials for the authors first name
				citation_trim_firstname = true,
				-- Max number of authors to write in the formatted citation
				-- following authors will be replaced by "et al."
				citation_max_auth = 2,
				-- Context awareness disabled by default
				context = false,
				-- Fallback to global/directory .bib files if context not found
				-- This setting has no effect if context = false
				context_fallback = true,
				-- Wrapping in the preview window is disabled by default
				wrap = false,
			},
			media_files = {
				-- filetypes whitelist
				-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
				filetypes = { "png", "webp", "jpg", "jpeg" },
				-- find command (defaults to `fd`)
				find_cmd = "fd",
			},
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
	})

	telescope.load_extension("media_files")
	telescope.load_extension("fzf")
	telescope.load_extension("advanced_git_search")
	telescope.load_extension("session-lens")
	telescope.load_extension("bibtex")
	-- telescope.load_extension("luasnip")
	require("telescope").load_extension("nerdy")
end

function M.mason()
	require("mason").setup({
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
	})
end

function M.lualine()
	local lualine_b = {}
	local lualine_c = {}
	local winbar = {}
	if vim.g.vimrc_lsp == "nvim-lsp" then
		lualine_b = { "branch", "diagnostics" }
		lualine_c = {
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
			-- theme = 'solarized',
			component_separators = { left = "", right = "" },
			-- leave them blank, or lualine will kill intro.
			-- https://github.com/nvim-lualine/lualine.nvim/issues/259#issuecomment-1890485361
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				-- do not override dapui's buttons
				winbar = {
					"dap-repl",
					"dapui_breakpoints",
					"dapui_console",
					"dapui_scopes",
					"dapui_watches",
					"dapui_stacks",
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
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { filename },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = winbar,
		inactive_winbar = {},
		extensions = { "fern", "quickfix", "nvim-dap-ui" },
	})
end

function M.gitsigns()
	require("gitsigns").setup({
		-- 比默认priority低1级, bookmarkspriority为10
		sign_priority = 9,
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Unstaged hunk navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end)

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end)

			-- Staged hunk navigation
			map("n", "]sc", function()
				gitsigns.nav_hunk("next", { target = "staged" })
			end)
			map("n", "[sc", function()
				gitsigns.nav_hunk("prev", { target = "staged" })
			end)

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
		base = vim.g.gitsign_default_base
	})
end

local colorscheme_loaded = false
function M.colorscheme()
	if not colorscheme_loaded then
		-- make winbar background transparent
		-- Reset coc.nvim highlight after colorscheme loaded
		-- See: https://github.com/neoclide/coc.nvim/issues/4857
		vim.cmd([[
		set termguicolors
		hi WinBar guibg=NONE
		hi! link CocInlayHint LspInlayHint
		hi link QuickPreview Normal
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
