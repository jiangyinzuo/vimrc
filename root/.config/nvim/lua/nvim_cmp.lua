local M = {}

local function cmp_format_fn(entry, vim_item)
	-- set a name for each source
	vim_item.menu = ({
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
	local cmp = require 'cmp'
	if vim.g.vimrc_lsp == 'nvim-lsp' then
		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				-- { name = 'vsnip' }, -- For vsnip users.
				{ name = 'luasnip' }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
				-- { name = 'snippy' }, -- For snippy users.
			}, {
				{
					name = 'omni',
					option = {
						disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' }
					}
				},
				{ name = 'buffer' },
				-- `cmd.setup.filetype('text', {...})` does not work.
				{
					name = "dictionary",
					keyword_length = 2,
				},
				{ name = 'path' },
			}),
			formatting = {
				format = cmp_format_fn
			},
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype({ 'tex', 'bib' }, {
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'vimtex', },
			}, {
				{ name = 'luasnip' }, -- For luasnip users.
				{ name = 'buffer' },
				{ name = 'path' },
				{
					name = "dictionary",
					keyword_length = 2,
				},
			}
			),
			formatting = {
				format = cmp_format_fn
			},
		})
		local dictfile = vim.api.nvim_get_option('dictionary')
		local dict = {
			["*"] = {},
			text = { dictfile },
			tex = { dictfile },
			markdown = { dictfile },
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "text,tex,markdown",
			callback = function(ev)
				require("cmp_dictionary").setup({
					exact_length = 2,
					paths = dict[ev.match] or dict["*"],
					first_case_insensitive = true,
					document = {
						enable = true,
						-- apt install wordnet
						command = { "wn", "${label}", "-over" },
					},
				})
			end,
		})
	end

	cmp.setup.filetype('gitcommit', {
		sources = cmp.config.sources({
			{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
		}, {
			{ name = 'buffer' },
		})
	})

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})

	local comparators = {
		cmp.config.compare.offset,
		cmp.config.compare.exact,
		cmp.config.compare.recently_used,
		cmp.config.compare.kind,
		cmp.config.compare.sort_text,
		cmp.config.compare.length,
		cmp.config.compare.order,
	}
	if vim.g.vimrc_lsp == 'nvim-lsp' then
		table.insert(comparators, require("clangd_extensions.cmp_scores"))
	end
	cmp.setup {
		-- ... rest of your cmp setup ...
		sorting = {
			comparators = comparators,
		},
	}
end

return M
