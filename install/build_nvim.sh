#!/bin/bash

. install/git.sh

PYTHON=/usr/bin/python3

commit=$1
$SUDO apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
$PYTHON -m pip install -U neovim

function _uninstall() {
	$SUDO cmake --build build/ --target uninstall
}

function _install() {
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	$SUDO make install
}

main https://github.com/neovim/neovim.git neovim $commit

