#!/bin/bash

PYTHON=/usr/bin/python3

commit=$1

sudo apt-get -y install ninja-build gettext cmake unzip curl build-essential
$PYTHON -m pip install -U neovim

function _uninstall() {
	sudo cmake --build build/ --target uninstall
}

function _install() {
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
}

. install/git.sh
main https://github.com/neovim/neovim.git neovim $commit

