#!/bin/bash

commit=$1

sudo apt-get install libevent-dev ncurses-dev build-essential bison pkg-config automake

function _uninstall() {
	sudo make uninstall
}

function _install() {
	sh autogen.sh
	./configure && make
	sudo make install
}

. install/git.sh
main https://github.com/tmux/tmux.git tmux $commit
