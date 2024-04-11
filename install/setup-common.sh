#!/bin/bash

soft_link_files=(
	.vim .ripgreprc .globalrc .tmux.conf .config/ctags .config/lazygit
	.config/vifm .gitconfig .gitconfig-ict .config/himalaya .config/clangd
	.config/nnn/plugins .config/nvim .condarc
)

echo_green() {
  echo -e "\033[32m$1\033[0m"
}

echo_yellow() {
	echo -e "\033[33m$1\033[0m"
}

_make_soft_link() {
	local src=$1
	local target=$2
	if ! [[ -e $target ]]; then
		if ln -s "$src" "$target"; then
			echo "ln -s $src $target success"
		fi
	else
		echo "File $target exists, skip."
	fi
}

setup() {

	# 检查 $VIMRC_ROOT 是否存在
	if [ -z "$VIMRC_ROOT" ]; then
	  # 如果不存在，则追加到 .bashrc
		echo_green "Add source ~/vimrc/root/bashrc to .bashrc:"
		echo "source ~/vimrc/root/bashrc" >> ~/.bashrc
		. ~/vimrc/root/bashrc
	fi

	echo_green "Setup soft links:"
	# nvim
	# ln -s $VIMRC_ROOT/.config/nvim ~/.config/nvim
	# ln -s $VIMRC_ROOT/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
	mkdir -p ~/.local/share/bash-completion/completions
	mkdir -p ~/.config/nnn
	for f in "${soft_link_files[@]}" ; do
		_make_soft_link "$VIMRC_ROOT"/"$f" ~/"$f"
	done

	# soft links for neovim
	_make_soft_link ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
	_make_soft_link ~/.vim/vimrc ~/.config/nvim/init.vim

	mkdir -p ~/gadgets
	_make_soft_link ~/gadgets ~/.vim/gadgets

	echo_green "Environment variables used:"
	echo DOC2="$DOC2"

	echo_green "Add the following to your .bashrc if you want to use pygments for gtags:"
	echo "export GTAGSLABEL=native-pygments"

	echo_yellow "NOTE: Change name and email in .gitconfig if needed."

	echo_green "Done!"
}

