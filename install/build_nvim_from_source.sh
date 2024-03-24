#!/bin/bash

pip3 install -U neovim

build_dir=$(pwd)/build
mkdir -p $build_dir
cd $build_dir

download_zip_and_build() {
	# 下载zip文件的URL
	ZIP_URL="https://github.com/neovim/neovim/archive/${LATEST_HASH}.zip"
	if [[ $PREVIOUS_HASH != 'null' && $PREVIOUS_HASH != '' ]]; then
		rm neovim-${PREVIOUS_HASH}.zip
	fi
	# 使用wget或curl下载zip文件
	wget $ZIP_URL -O neovim-${LATEST_HASH}.zip
	# 或者使用curl: curl -L $ZIP_URL -o neovim-${LATEST_HASH}.zip
	unzip neovim-${LATEST_HASH}.zip
	cd neovim-${LATEST_HASH}
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
}

# GitHub API URL用于获取最新的nightly release信息
API_URL="https://api.github.com/repos/neovim/neovim/releases/tags/nightly"

# 用于存储上一次commit hash的文件路径
PREVIOUS_HASH_FILE="nvim_previous_commit_hash.txt"

# 获取最新的commit hash
LATEST_HASH=$(curl -H "Accept: application/vnd.github.v3+json" $API_URL | jq -r '.target_commitish')

# 检查previous_commit_hash.txt文件是否存在，如果不存在，则创建
if [ ! -f "$PREVIOUS_HASH_FILE" ]; then
	echo "文件不存在，创建 $PREVIOUS_HASH_FILE 并保存当前commit hash."
	if [[ $LATEST_HASH != 'null' ]] ; then
		echo $LATEST_HASH >$PREVIOUS_HASH_FILE
	else
		echo "获取最新的commit hash失败。"
	fi
	download_zip_and_build
	exit 0
fi

# 读取previous_commit_hash.txt中的hash
PREVIOUS_HASH=$(cat $PREVIOUS_HASH_FILE)

# 比较最新的commit hash和之前保存的hash
if [ "$LATEST_HASH" != "$PREVIOUS_HASH" ]; then
	echo "Commit hash有变化，下载zip文件..."
	download_zip_and_build
	# 更新previous_commit_hash.txt文件
	echo $LATEST_HASH >$PREVIOUS_HASH_FILE
else
	echo "Commit hash未变化，无需下载。"
fi
