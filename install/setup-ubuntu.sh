#!/bin/bash

set -v

# 版本号小于18.04

# apt install -y npm
# npm install -g n
# n latest

# :MasonInstall lua-language-server cpptools

# neovim json lsp
# npm i -g vscode-langservers-extracted

# ripgrep:
# any-jump.vim cpp需要PCRE2 feature
# Ubuntu18.04 需要前往https://github.com/BurntSushi/ripgrep/releases
# 下载.deb文件(ripgrep_14.1.0-1_amd64.deb 可以用)
#
# apt install -y golang clangd
# Leaderf needs python3-dev and python3-distutils
# wamerican: American English字典文件，安装后位于/usr/share/dict/american-english, 用于vim dictionary
# wordnet: nvim cmp dictionary 可以用wordnet解释单词
apt-get install -y libgtk-3-dev libxt-dev vim-gtk3 ripgrep fzf fd-find tree bat nodejs npm git sqlformat vifm python3-dev python3-distutils wamerican wordnet

# ripgrep-all（master分支）
# See: https://github.com/phiresky/ripgrep-all/issues/113
# apt install ripgrep pandoc poppler-utils ffmpeg

# checkrepo.py needs GitPython
pip3 install GitPython

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install git-delta
