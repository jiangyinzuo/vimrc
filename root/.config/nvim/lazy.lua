local config = require("config")
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

vim.api.nvim_command("source ~/.vim/vimrc.d/plugin_setup.vim")
vim.api.nvim_command("source ~/.vim/vimrc.d/ai.vim")

-- https://gist.github.com/BlueDrink9/474b150c44d41b80934990c0acfb00be
require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.development" },
}, {
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
	install = {
		missing = config.lazy_nvim_install_missing,
	},
})

local function config_clipboard()
	if vim.fn.has("wsl") == 1 then
		-- clip.exe会导致中文乱码，使用默认的wl-copy
		-- See: ~/vimrc/wsl/README.md
		-- vim.g.clipboard = {
		-- 	name = 'WslClipboard',
		-- 	copy = { ['+'] = 'clip.exe', ['*'] = 'clip.exe', },
		-- 	paste = {
		-- 		['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		-- 		['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		-- 	},
		-- 	['cache_enabled'] = 0,
		-- }
	else
		vim.g.clipboard = {
			name = "OSC 52",
			copy = {
				["+"] = require("vim.ui.clipboard.osc52").copy("+"),
				["*"] = require("vim.ui.clipboard.osc52").copy("*"),
			},
			paste = {
				["+"] = require("vim.ui.clipboard.osc52").paste("+"),
				["*"] = require("vim.ui.clipboard.osc52").paste("*"),
			},
		}
	end
end

-- lazy.nvim has reset packpath, so we need to add ~/.vim back
--
-- make winbar background transparent
-- Reset coc.nvim highlight after colorscheme loaded
-- See: https://github.com/neoclide/coc.nvim/issues/4857
vim.cmd([[
set packpath+=~/.vim
set termguicolors
hi WinBar guibg=NONE
hi! link CocInlayHint LspInlayHint
hi link QuickPreview Normal
]])
config_clipboard()

-- https://github.com/neovim/neovim/pull/27855
require("vim._extui").enable({ enable = true, msg = { target = "cmd" } })
