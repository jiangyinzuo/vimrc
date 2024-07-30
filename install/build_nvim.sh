#!/bin/bash

PYTHON=/usr/bin/python3

commit=$1
apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
$PYTHON -m pip install -U neovim

function _uninstall() {
	cmake --build build/ --target uninstall
}

function _install() {
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	make install
}

. install/git.sh
main https://github.com/neovim/neovim.git neovim $commit

