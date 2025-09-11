#!/bin/bash
# vim: set noet:

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $SCRIPT_DIR/rust-toolchain.sh

if command -v sudo >/dev/null 2>&1; then
	# sudo 命令存在，使用sudo执行命令
	SUDO=sudo
else
	# sudo 命令不存在，直接执行命令
	SUDO=
fi

prompt=""

# 字典：Ubuntu的wamerican和CentOS的words格式不同，因此CentOS系统不安装字典。
# python*: LeaderF
$SUDO yum install python-devel python3 python3-devel

# nvim-treesitter和pynvim需要高版本gcc，切换devtoolset来使用高版本gcc，或手动添加-std=c99 flag
# https://github.com/nvim-treesitter/nvim-treesitter/pull/7490
pip3 install neovim

if command -v snap >/dev/null 2>&1; then
	$SUDO snap install ripgrep --classic
fi

install_git_delta

# lazy.nvim requires Git >= 2.19.0
prompt=$prompt"
		=== git ===
		安装高版本Git: https://www.endpointdev.com/blog/2021/12/installing-git-2-on-centos-7/
"

# 加上双引号才能echo换行符
echo "$prompt"
