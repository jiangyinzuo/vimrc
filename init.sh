#/bin/bash

ln -s ~/vimrc/root/.vimrc ~/.vimrc
ln -s ~/vimrc/root/vimrc.d ~/vimrc.d
ln -s ~/vimrc/root/.vim ~/.vim
ln -s ~/vimrc/root/.ripgreprc ~/.ripgreprc
echo 'source ~/vimrc/root/bashrc' >> ~/.bashrc
