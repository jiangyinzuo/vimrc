--- Using lazy.nvim to manage non Neovim related repositories
--- https://github.com/folke/lazy.nvim/discussions/1488
return {
	{
		"jiangyinzuo/gdb-bt-forest",
		lazy = true, -- so neovim doesn't try to load it
		enabled = true,
	},
	{
		"jiangyinzuo/gdb-scripts",
		lazy = true, -- so neovim doesn't try to load it
		enabled = true,
	}
}
