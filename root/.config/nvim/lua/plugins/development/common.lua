return {
	{
		"danymat/neogen",
		config = true,
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
	},
	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					c = { "clang-format" },
					cpp = { "clang-format" },
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", vim.g.python_formatter },
					-- You can customize some of the format options for the filetype (:help conform.format)
					rust = { "rustfmt" },
					go = { "gofmt" },
					java = { "google-java-format" },
					-- Conform will run the first available formatter
					javascript = { "prettierd", "prettier", stop_after_first = true },
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
			})
			vim.keymap.set({ "n", "x" }, "<leader>fmt", function()
				conform.format({ async = true })
			end, { noremap = true, silent = true })
		end,
	},
}
