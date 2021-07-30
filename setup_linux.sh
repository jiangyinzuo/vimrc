#!/bin/sh
set -e

cat ./vimrcs/basic.vim > ~/.vimrc

mkdir -p ~/.vim/colors
cp -r ./colors/* ~/.vim/colors

cp -r ./vimrcs/vimrc.d/ ~/.vimrc.d

cp ./coc-settings.json ~/.vim/

mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -fLo ~/.vim/plugin/gtags.vim --create-dirs \
	https://cvs.savannah.gnu.org/viewvc/*checkout*/global/global/gtags.vim

curl -fLo ~/.vim/plugin/gtags-cscope.vim --create-dirs \
	https://cvs.savannah.gnu.org/viewvc/*checkout*/global/global/gtags-cscope.vim

echo done!
