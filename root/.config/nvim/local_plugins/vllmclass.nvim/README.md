# vllmclass.nvim

本地 Neovim 插件，提供 vLLM 调用树类名高亮与 Markdown `vllmclass` 树折叠。

由 lazy.nvim 从 Neovim 配置目录下的 `local_plugins/vllmclass.nvim` 加载。模块源码位于 `lua/vllmclass/`。

在仓库根目录运行真实文档回归测试：

```sh
nvim --headless note/vllm/the-life-of-a-request.md \
	'+luafile ~/.config/nvim/local_plugins/vllmclass.nvim/tests/run.lua' +qa!
```
