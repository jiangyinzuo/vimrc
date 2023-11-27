#!/bin/bash

set -v

# apt install -y npm
# npm install -g n
# n latest

# :MasonInstall lua-language-server cpptools

# neovim json lsp
# npm i -g vscode-langservers-extracted

# apt install -y golang clangd
# Leaderf needs python3-dev and python3-distutils
# wamerican: American English字典文件，安装后位于/usr/share/dict/american-english, 用于vim dictionary
apt-get install -y vim-gtk3 ripgrep fzf fd-find tree bat nodejs npm git sqlformat vifm python3-dev python3-distutils \
	wamerican

# ripgrep-all（master分支）
# See: https://github.com/phiresky/ripgrep-all/issues/113
# apt install ripgrep pandoc poppler-utils ffmpeg
