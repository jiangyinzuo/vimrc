#!/bin/bash

commit=$1

apt-get install libevent-dev ncurses-dev build-essential bison pkg-config automake

function _uninstall() {
	make uninstall
}

function _install() {
	sh autogen.sh
	./configure && make
	make install
}

. install/git.sh
main https://github.com/tmux/tmux.git tmux $commit
