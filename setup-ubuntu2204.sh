#!/bin/bash

set -v

apt install -y npm
npm install -g n
n latest

# neovim json lsp
# npm i -g vscode-langservers-extracted

apt install -y ripgrep fzf fd-find tree bat clangd

# ripgrep-all（master分支）
# See: https://github.com/phiresky/ripgrep-all/issues/113
# apt install ripgrep pandoc poppler-utils ffmpeg
