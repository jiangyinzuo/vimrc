if require("config").load_plugin.development.writing then
	local has_quarto_executable = false
	return {
		{
			"quarto-dev/quarto-nvim",
			cond = has_quarto_executable,
			dependencies = {
				"jmbuhr/otter.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
		},
		{
			-- do not lazy load vimtex
			"lervag/vimtex",
			cond = (vim.fn.has("wsl") == 1) and vim.g.has_pdflatex_executable ~= 0,
			init = function()
				vim.api.nvim_command("source ~/.vim/vimrc.d/latex.vim")
			end,
		},
	}
else
	return {}
end
