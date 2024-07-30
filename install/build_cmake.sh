#!/bin/bash

commit=$1

apt-get -y install libssl-dev

function _uninstall() {
	make uninstall
}

function _install() {
	./bootstrap && make && make install
}

. install/git.sh
main https://gitlab.kitware.com/cmake/cmake.git cmake $commit
