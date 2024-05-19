#!/bin/bash

commit=$1

if [ -x "$(command -v apt)" ]; then
	sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
elif [ -x "$(command -v yum)" ]; then
	yum -y install pkgconfig automake gcc zlib-devel pcre-devel xz-devel
fi

function _uninstall() {
	sudo make uninstall
}

function _install() {
	./build.sh
	sudo make install
}

. install/git.sh
main https://github.com/satanson/the_silver_searcher the_silver_searcher $commit
