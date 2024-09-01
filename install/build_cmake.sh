#!/bin/bash

. install/git.sh

commit=$1

$SUDO apt-get -y install libssl-dev

function _uninstall() {
	$SUDO make uninstall
}

function _install() {
	./bootstrap && make && $SUDO make install
}

main https://gitlab.kitware.com/cmake/cmake.git cmake $commit
