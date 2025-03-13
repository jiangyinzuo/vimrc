if vim.fn.has('wsl') == 1 then
	return {
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			-- or "cd app && yarn install"
			build = "cd app && npx --yes yarn install",
			init = function()
				vim.g.mkdp_filetypes = { "markdown", "quarto" }
			end,
			ft = { "markdown", "quarto" },
		},
	}
else
	return {}
end
