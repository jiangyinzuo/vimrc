#!/bin/bash

set -v

apt install -y npm
npm install -g n
n latest

# neovim json lsp
# npm i -g vscode-langservers-extracted

apt install -y ripgrep fzf fd-find tree bat clangd
