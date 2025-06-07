#!/bin/bash

set -e

. install/git.sh

commit=$1

MAKE_FLAG=${MAKE_FLAG:-"-j$((`nproc`-2))"}
CONFIGURE_FLAG=${CONFIGURE_FLAG:-"--enable-gui --with-x"}
# $SUDO apt-get -y install libgtk-3-dev libxt-dev libncurses-dev

function _uninstall() {
	$SUDO make uninstall
}

function _install() {
	./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes --with-python3-config-dir ${CONFIGURE_FLAG}
	make ${MAKE_FLAG}
	$SUDO make install
}

main https://github.com/vim/vim.git vim $commit
