--- 获取光标下的语言名称
local function get_pos_lang()
	local buf = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1

	local ok, parser = pcall(vim.treesitter.get_parser, buf)
	if not ok or not parser then
		return ""
	end

	local tree = parser:language_for_range({ row, col, row, col })
	return tree:lang()
end

--- 判断特定语言的 Treesitter 解析器是否已安装
local function has_parser(lang)
	if lang == "" then
		return false
	end
	-- 尝试获取语言配置，如果返回 nil 则说明该语言未注册/未安装解析器
	return vim.treesitter.language.get_lang(lang) ~= nil
end

return {
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				-- Directory to install parsers and queries to
				install_dir = vim.fn.stdpath("data") .. "/site",
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(ev)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.fs.normalize(ev.file))
					if ok and stats and stats.size < max_filesize then
						pcall(vim.treesitter.start, ev.buf)
						-- vim.bo[ev.buf].syntax = "on" -- Use regex based syntax-highlighting as fallback as some plugins might need it
						-- vim.wo.foldlevel = 99
						-- vim.wo.foldmethod = "expr"
						-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folds
						-- vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- Use treesitter for indentation
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		config = function()
			-- configuration
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = false,
				},
			})

			-- keymaps
			-- You can use the capture groups defined in `textobjects.scm`
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end)
			-- You can also use captures from other query groups like `locals.scm`
			vim.keymap.set({ "x", "o" }, "as", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
			end)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 30, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		},
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
	{
		"Wansmer/treesj",
		keys = { "gJ" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({ use_default_keymaps = false })

			vim.keymap.set("n", "gJ", function()
				local tsj = require("treesj")
				local tsj_langs = require("treesj.langs").presets
				local lang = get_pos_lang()

				-- 只有当：解析器已安装 且 TreeSJ 有对应预设时，才执行 TreeSJ
				if has_parser(lang) and tsj_langs[lang] then
					tsj.toggle({ split = { recursive = true } })
				else
					-- 否则执行原生 gJ，! 确保不触发递归
					vim.cmd("normal! gJ")
				end
			end, { desc = "TreeSJ toggle or fallback to default gJ" })
		end,
	},
}
