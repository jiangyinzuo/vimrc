if require("config").load_plugin.development.writing then
	local detect = require("detect")
	local has_quarto_executable = detect.has_quarto_executable
	return {
		{
			"quarto-dev/quarto-nvim",
			cond = vim.g.vimrc_lsp == "nvim-lsp" and has_quarto_executable,
			dependencies = {
				"jmbuhr/otter.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
		},
		{
			-- do not lazy load vimtex
			"lervag/vimtex",
			cond = (vim.fn.has("wsl") == 1) and detect.has_pdflatex_executable,
			init = function()
				vim.api.nvim_command("source ~/.vim/vimrc.d/latex.vim")
			end,
		},
	}
else
	return {}
end
