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
	local cmp = require("cmp")
	if vim.g.vimrc_lsp == "nvim-lsp" then
		local feedkey = function(key, mode)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
		end
		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end
		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				-- ["<C-Space>"] = cmp.mapping.complete(),
				["<C-c>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				-- 作者：贺呵呵
				-- 链接：https://www.zhihu.com/question/656229461/answer/3506519415
				-- 来源：知乎
				-- 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
				["<C-j>"] = cmp.mapping(function(fallback)
					-- if cmp.visible() then
					-- 	cmp.select_next_item()
					if vim.snippet.active({ direction = 1 }) then
						feedkey("<cmd>lua vim.snippet.jump(1)<CR>", "")
					elseif has_words_before() then
						cmp.complete()
					else
						fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
					end
				end, { "i", "s" }),
				["<C-k>"] = cmp.mapping(function()
					-- if cmp.visible() then
					-- 	cmp.select_prev_item()
					if vim.snippet.active({ direction = -1 }) then
						feedkey("<cmd>lua vim.snippet.jump(-1)<CR>", "")
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				-- NOTE: 越后面优先级越高
				-- `cmd.setup.filetype('text', {...})` does not work.
				{
					name = "dictionary",
					keyword_length = 2,
				},
				{ name = "path" },
				{ name = "buffer" },
				{
					name = "omni",
					option = {
						disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
					},
				},
				{ name = "nvim_lsp" },
				snippet_source,
			}),
			formatting = {
				format = cmp_format_fn,
			},
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype({ "tex", "bib" }, {
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "vimtex" },
			}, {
				snippet_source,
				{ name = "buffer" },
				{ name = "path" },
				{
					name = "dictionary",
					keyword_length = 2,
				},
			}),
			formatting = {
				format = cmp_format_fn,
			},
		})
		local dictfile = vim.api.nvim_get_option_value("dictionary", {})
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

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
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
	if vim.g.vimrc_lsp == "nvim-lsp" then
		table.insert(comparators, require("clangd_extensions.cmp_scores"))
	end
	cmp.setup({
		-- ... rest of your cmp setup ...
		sorting = {
			comparators = comparators,
		},
	})
end

return M
