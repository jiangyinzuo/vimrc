#!/bin/bash

rg -l '[[palette]]' ~/.vim/after  ~/.vim/ftplugin ~/.vim/plugin ~/.vim/vimrc.d ~/.vim/vimrc | xargs sed -n 's/.*\[\[palette\]\]\(.*\)/\1/p'
cat ~/.vim/doc/palette.txt
