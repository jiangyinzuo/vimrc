# Terminal

## WezTerm

WSL快速编辑wezterm配置文件
```bash
export WEZTERM=/mnt/c/Users/Jiang\ Yinzuo/.wezterm.lua
# 双引号不能省略
vim "$WEZTERM"
```

不要全局设置 `exit_behavior = "Hold"`，否则普通 shell 的 Ctrl-D 也会留下窗口。
vimrc 中的 `:WeztermSpawn [program] [args...]` 单独包装任务：退出后显示退出码，
保留输出直到按 Enter；确认后以状态 0 结束包装进程，让 WezTerm 关闭 tab。
不带参数时运行当前 `$SHELL`。这个包装使用 POSIX `sh`，Windows WezTerm 下通过现有的 WSL 路由运行。

## 其它terminal

- ghostty
- [rio](https://rioterm.com/)
- alacritty
- warp
    - AI
- waveterm
    - AI
    - 浏览器
    - 图形UI
