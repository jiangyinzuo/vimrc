#!/bin/bash

sudo apt-get install libevent-dev ncurses-dev build-essential bison pkg-config automake

build_dir=$(pwd)/build
mkdir -p $build_dir
cd $build_dir

wget https://github.com/tmux/tmux/archive/refs/heads/master.zip -O tmux-master.zip
unzip tmux-master.zip
cd tmux-master

sh autogen.sh
./configure && make
sudo make install
