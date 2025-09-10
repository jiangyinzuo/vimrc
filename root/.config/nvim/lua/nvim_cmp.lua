local M = {}

local snippet_source =
	-- { name = 'vsnip' } -- For vsnip users.
	-- { name = 'luasnip' } -- For luasnip users.
	-- { name = 'ultisnips' } -- For ultisnips users.
	-- { name = 'snippy' } -- For snippy users.
	-- For native neovim snippets (Neovim v0.10+)
	{
		name = "snippets",
		max_item_count = 10,
		priority = 10,
	}

local function cmp_format_fn(entry, vim_item)
	-- set a name for each source
	vim_item.menu = ({
		snippets = "[Snip]",
		nvim_lsp = "[LSP]",
		buffer = "[Buffer]",
		omni = "[Omni]",
		dictionary = "[Dict]",
		path = "[Path]",
		vimtex = "[Vimtex]" .. (vim_item.menu ~= nil and vim_item.menu or ""),
	})[entry.source.name]
	return vim_item
end

function M.nvim_cmp()
	require("cmp_dictionary").setup({
		exact_length = 2,
		paths = { vim.api.nvim_get_option_value("dictionary", {}) },
		first_case_insensitive = true,
		document = {
			enable = vim.fn.executable("wn") ~= 0,
			-- apt install wordnet
			command = { "wn", "${label}", "-over" },
		},
	})
	local cmp = require("cmp")
	if vim.g.vimrc_lsp == "nvim-lsp" then
		local feedkey = function(key, mode)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
		end

		local comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			-- cmp.config.compare.scopes,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			-- cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		}
		if vim.g.vimrc_lsp == "nvim-lsp" then
			table.insert(comparators, 5, require("clangd_extensions.cmp_scores"))
		end

		cmp.setup({
			sorting = {
				-- priority_weight = 2,
				comparators = comparators,
			},
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
					vim.notify("<S-n>/<S-p> 前后跳转snippet, <C-c>退出snippet")
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-c>"] = cmp.mapping(function(fallback)
					local need_fallback = true
					if cmp.visible() then
						cmp.abort()
						need_fallback = false
					end
					if vim.snippet.active() then
						vim.snippet.stop()
						need_fallback = false
					end
					if need_fallback then
						fallback()
					end
				end, {"i", "s"}),
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					else
						fallback()
					end
				end, {"i", "s"}),
				["<C-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback() -- The fallback function sends a already mapped key.
					end
				end, { "i", "s" }),
				["<C-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback() -- The fallback function sends a already mapped key.
					end
				end, { "i", "s" }),
				["<S-n>"] = cmp.mapping(function(fallback)
					if vim.snippet.active({ direction = 1 }) then
						vim.snippet.jump(1)
					else
						fallback() -- The fallback function sends a already mapped key.
					end
				end, { "i", "s" }),
				["<S-p>"] = cmp.mapping(function(fallback)
					if vim.snippet.active({ direction = -1 }) then
						vim.snippet.jump(-1)
					else
						fallback() -- The fallback function sends a already mapped key.
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				-- NOTE: 不指定优先级时，越后面优先级越低
				{ name = "async_path", priority = 10 },
				{ name = "buffer", priority = 10 },
				{
					name = "omni",
					option = {
						disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
					},
					priority = 10,
				},
				{ name = "nvim_lsp", priority = 10 },
				snippet_source,
			}),
			formatting = {
				format = cmp_format_fn,
			},
		})
		-- Set configuration for specific filetype.
		cmp.setup.filetype({ "tex", "bib" }, {
			sources = cmp.config.sources({
				{ name = "nvim_lsp", priority = 10 },
				{ name = "vimtex", priority = 10 },
				snippet_source,
			}, {
				{ name = "buffer", priority = 10 },
				{ name = "async_path", priority = 10 },
				{
					name = "dictionary",
					keyword_length = 2,
					priority = 10,
				},
			}),
			formatting = {
				format = cmp_format_fn,
			},
		})
		cmp.setup.filetype({ "markdown" }, {
			sources = cmp.config.sources({
				{ name = "nvim_lsp", priority = 10 },
				snippet_source,
				{ name = "buffer", priority = 10 },
				{ name = "async_path", priority = 10 },
				{
					name = "dictionary",
					keyword_length = 2,
					priority = 10,
				},
			}),
			formatting = {
				format = cmp_format_fn,
			},
		})
	end

	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({
			{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
		}, {
			{ name = "buffer" },
		}),
	})

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	local cmp_cmdline_ignore_cmds = vim.fn.has("wsl") == 1 and { "Man", "!", "terminal" } or { "Man" }
	-- Use cmdline & async_path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "async_path" },
		}, {
			{
				name = "cmdline",
				option = {
					ignore_cmds = cmp_cmdline_ignore_cmds,
				},
			},
		}),
	})
end

return M
