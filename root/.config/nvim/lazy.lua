-- Linux: ~/.local/share/nvim/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- https://gist.github.com/BlueDrink9/474b150c44d41b80934990c0acfb00be
require("lazy").setup("plugins", {
	root = vim.g.vim_plug_dir,
	performance = {
		-- allow packadd <package name> in .project.vim
		reset_packpath = false,
		rtp = {
			paths = {
				"~/.vim",
				"~/.vim/after",
			},
		},
	},
})

-- lazy.nvim has reset packpath, so we need to add ~/.vim back
vim.cmd([[set packpath+=~/.vim]])

-- load colorscheme at the end to avoid black background on startup
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = require("plugins_setup").colorscheme,
})
