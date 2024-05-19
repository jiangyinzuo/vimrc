#!/bin/bash

commit=$1

sudo apt-get -y install ninja-build gettext cmake unzip curl build-essential
pip3 install -U neovim

function _uninstall() {
	sudo cmake --build build/ --target uninstall
}

function _install() {
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
}

. install/git.sh
main https://github.com/neovim/neovim.git neovim $commit

