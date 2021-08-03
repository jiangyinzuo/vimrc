#!/bin/sh
set -e

ln -s `pwd`/init.vim ~/.vimrc
ln -s `pwd`/vimrc.d ~/vimrc.d

mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -fLo ~/.vim/plugin/gtags.vim --create-dirs \
	https://cvs.savannah.gnu.org/viewvc/*checkout*/global/global/gtags.vim

curl -fLo ~/.vim/plugin/gtags-cscope.vim --create-dirs \
	https://cvs.savannah.gnu.org/viewvc/*checkout*/global/global/gtags-cscope.vim

echo done!
