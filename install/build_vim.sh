#!/bin/bash

commit=$1

MAKE_FLAG=${MAKE_FLAG:-"-j$((`nproc`-2))"}

apt-get -y install libgtk-3-dev libxt-dev libncurses-dev

function _uninstall() {
	make uninstall
}

function _install() {
	./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes --with-python3-config-dir --enable-gui --with-x
	make ${MAKE_FLAG}
	make install
}

. install/git.sh
main https://github.com/vim/vim.git vim $commit
