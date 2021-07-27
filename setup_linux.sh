#!/bin/sh
set -e

cat ./vimrcs/basic.vim > ~/.vimrc

mkdir -p ~/.vim/colors
cp -r ./colors/* ~/.vim/colors

mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


