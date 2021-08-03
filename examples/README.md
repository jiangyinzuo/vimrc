# Example Configurations

## vimspector
see:
- [https://code.visualstudio.com/docs/editor/variables-reference](https://code.visualstudio.com/docs/editor/variables-reference)

- [vscode-go](https://github.com/golang/vscode-go/blob/master/docs/debugging.md#launch-configurations)

## coc-config.json
see:
- [https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file](https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file)

Put `coc-config.json` on `$HOME/.vim` for global and `:CocLocalConfig` for workspace configuration file.

For c/cpp development, do not enable both `clangd` and `ccls`. clangd is enabled by default.
