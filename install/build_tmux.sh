#!/bin/bash

. install/git.sh

commit=$1

if [ -f /etc/os-release ]; then
	. /etc/os-release
	if [ "$ID" = "ubuntu" ]; then
		$SUDO apt-get install libevent-dev ncurses-dev build-essential bison pkg-config automake
	elif [ "$ID" = "centos" ]; then
		$SUDO yum install libevent-devel ncurses-devel gcc make bison automake
	fi
else
	echo "Unsupported Linux distribution"
	exit 1
fi

function _uninstall() {
	$SUDO make uninstall
}

function _install() {
	sh autogen.sh
	./configure && make
	$SUDO make install
}
# tmux3.4中打开nvim，会瞬间显示`SIXEL IMAGE (1x1)` https://github.com/tmux/tmux/issues/4499
# 该bug在tmux3.6+修复
main https://github.com/tmux/tmux.git tmux $commit
