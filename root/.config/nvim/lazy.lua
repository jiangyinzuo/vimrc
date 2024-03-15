local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- https://gist.github.com/BlueDrink9/474b150c44d41b80934990c0acfb00be
require("lazy").setup("plugins", {
	root = vim.g.vim_plug_dir,
	performance = {
		reset_packpath = true,
		rtp = {
			paths = {
				'~/.vim'
			}
		}
	}
})

-- lazy.nvim has reset packpath, so we need to add ~/.vim back
vim.cmd[[set packpath+=~/.vim]]
