#!/bin/bash

plugged_dir=~/plugged
if [ ! -d $plugged_dir ]; then
	echo "plugged dir not found"
	exit 1
fi

pushd $plugged_dir

tar -cf plugged-cpp.tar coc-fzf fzf tabular vim-cpp-modern vim-markdown vim-test \
	LeaderF LeaderF-floaterm coc.nvim fzf.vim tagbar vim-oscyank any-jump.vim \
	traces.vim vim-floaterm vim-sneak asyncrun.vim nordtheme ultisnips vim-fugitive \
	vim-snippets asynctasks.vim dracula vim-gitgutter vim-solarized8 vista.vim \
	auto-pairs editorconfig-vim vim-code-dark vim-go vim-surround vim-eunuch \
	vim-qf

popd
