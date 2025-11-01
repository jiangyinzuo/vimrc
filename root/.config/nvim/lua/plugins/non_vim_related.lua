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
	},
	--- Satanson's perl scripts: https://github.com/satanson/cpp_etudes
	--- C++阅码神器cpptree.pl和calltree.pl的使用 - satanson的文章 - 知乎 https://zhuanlan.zhihu.com/p/339910341
	{
		"satanson/cpp_etudes",
		lazy = true, -- so neovim doesn't try to load it
		enabled = true,
	}
}
