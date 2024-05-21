#!/bin/bash

commit=$1

sudo apt-get -y install libssl-dev

function _uninstall() {
	sudo make uninstall
}

function _install() {
	./bootstrap && make && sudo make install
}

. install/git.sh
main https://gitlab.kitware.com/cmake/cmake.git cmake $commit
