#!/bin/bash

rg -l '[[palette]]' ~/.vim/vimrc.d ~/.vim/vimrc | xargs sed -n 's/.*\[\[palette\]\]\(.*\)/\1/p'
cat ~/.vim/doc/palette.cnx
