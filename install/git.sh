#!/bin/bash

function git_clone_and_cd() {
	local url=$1
	local repo=$2

	# git clone first if not exist
	if [ ! -d $repo ]; then
		git clone --no-checkout --depth=1 $url $repo
		cd $repo
	else
		cd $repo
		_uninstall
	fi
}

function git_fetch_and_reset() {
	local commit=$1
	git fetch origin $commit --depth=1
	git reset --hard FETCH_HEAD
}

function main() {
	local url=$1
	local repo=$2
	local commit=$3
	build_dir=`pwd`/build
	mkdir -p $build_dir
	sudo chmod 777 $build_dir
	cd $build_dir
	git_clone_and_cd $url $repo
	git_fetch_and_reset $commit
	_install
}
