if vim.fn.has('wsl') == 1 then
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
		name = 'OSC 52',
		copy = {
			['+'] = require('vim.ui.clipboard.osc52').copy('+'),
			['*'] = require('vim.ui.clipboard.osc52').copy('*'),
		},
		paste = {
			['+'] = require('vim.ui.clipboard.osc52').paste('+'),
			['*'] = require('vim.ui.clipboard.osc52').paste('*'),
		},
	}
end
