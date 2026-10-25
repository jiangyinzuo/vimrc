#!/bin/bash

soft_link_files=(
	.condarc
	.config/clangd
	.config/ctags
	.config/himalaya
	.config/lazygit
	.config/mods
	.config/nvim
	.config/zellij
	.dircolors
	.omp/agent/models.yml
	# 企业需要用企业邮箱、github代理，防止误操作覆盖网络代理
	.gitconfig
	# .gitconfig-ict
	.globalrc
	.ripgreprc
	.tmux.conf
	.vim
)

echo_green() {
	echo -e "\033[32m$1\033[0m"
}

echo_yellow() {
	echo -e "\033[33m$1\033[0m"
}

_copy_file() {
	local src=$1
	local target=$2
	local result="target did not exist"
	if [[ ! -f "$src" ]]; then
		echo "File $src does not exist or is not a regular file, copy failed." >&2
		return 1
	fi
	local target_dir
	target_dir=$(dirname -- "$target")
	if ! mkdir -p -- "$target_dir"; then
		echo "Create directory $target_dir failed, copy skipped." >&2
		return 1
	fi
	if [[ -e "$target" || -L "$target" ]]; then
		if ! mv -T -- "$target" "${target}.bak"; then
			echo "Backup $target to ${target}.bak failed, copy skipped." >&2
			return 1
		fi
		result="target existed and was backed up to ${target}.bak"
	fi
	if cp -- "$src" "$target"; then
		echo "cp $src $target success ($result)."
	else
		echo "cp $src $target failed ($result)." >&2
		return 1
	fi
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

do_setup() {
	# 检查 $VIMRC_ROOT 是否存在
	if [ -z "$VIMRC_ROOT" ]; then
		# 如果不存在，则追加到 .bashrc
		echo_green "Add source ~/vimrc/root/bashrc to .bashrc:"
		echo "source ~/vimrc/root/bashrc" >>~/.bashrc
		. ~/vimrc/root/bashrc
	fi

	echo_green "Setup soft links:"
	mkdir -p ~/.local/share/bash-completion/completions
	mkdir -p ~/.config
	for f in "${soft_link_files[@]}"; do
		_make_soft_link "$VIMRC_ROOT"/"$f" ~/"$f"
	done

	# soft links for neovim
	_make_soft_link ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
	_make_soft_link ~/.vim/vimrc ~/.config/nvim/init.vim

	mkdir -p ~/gadgets
	_make_soft_link ~/gadgets ~/.vim/gadgets
	_copy_file "$VIMRC_ROOT"/.codex/config.toml ~/.codex/config.toml
	_copy_file "$VIMRC_ROOT"/.omp/agent/models.yml ~/.omp/agent/models.yml

	echo_green "Environment variables used:"
	echo DOC2="$DOC2"

	echo_green "Add the following to your .bashrc if you want to use pygments for gtags:"
	echo "export GTAGSLABEL=native-pygments"
	echo_yellow "NOTE: Change name and email in .gitconfig if needed."
	echo_green "Done!"
}

do_setup
