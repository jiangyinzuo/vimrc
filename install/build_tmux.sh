#!/bin/bash

. install/git.sh

commit=$1

$SUDO apt-get install libevent-dev ncurses-dev build-essential bison pkg-config automake

function _uninstall() {
	$SUDO make uninstall
}

function _install() {
	sh autogen.sh
	./configure && make
	$SUDO make install
}

main https://github.com/tmux/tmux.git tmux $commit
