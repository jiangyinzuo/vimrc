#!/bin/bash

set -v

UBUNTU_CODE_NAME=$(lsb_release -c | cut -f2)
# install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable

# install nodejs
# alternative: n
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# source .bashrc
# nvm install --lts

# install llvm toolchain
# https://apt.llvm.org/
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo cat >> /etc/apt/sources.list.d/llvm.list << EOF
deb http://apt.llvm.org/$UBUNTU_CODE_NAME/ llvm-toolchain-$UBUNTU_CODE_NAME main
deb-src http://apt.llvm.org/$UBUNTU_CODE_NAME/ llvm-toolchain-$UBUNTU_CODE_NAME main
EOF
sudo apt-get update
sudo apt-get install -y clangd

apt-get install -y neovim
pip install neovim

# ripgrep:
# any-jump.vim cpp需要PCRE2 feature
# Ubuntu18.04 需要前往https://github.com/BurntSushi/ripgrep/releases
# 下载.deb文件(ripgrep_14.1.0-1_amd64.deb 可以用)
#
# apt install -y golang
# Leaderf needs python3-dev and python3-distutils
# wamerican: American English字典文件，安装后位于/usr/share/dict/american-english, 用于vim dictionary
# wordnet: nvim cmp dictionary 可以用wordnet解释单词
apt-get install -y ripgrep fd-find tree bat git cmake sqlformat python3-dev python3-distutils wamerican

# ripgrep-all（master分支）
# See: https://github.com/phiresky/ripgrep-all/issues/113
# apt install ripgrep pandoc poppler-utils ffmpeg

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# cargo install git-delta

# install vim-gtk3
# apt-get install -y libgtk-3-dev libxt-dev vim-gtk3
