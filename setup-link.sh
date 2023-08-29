#/bin/bash

# 检查 $VIMRC_ROOT 是否存在
if [ -z "$VIMRC_ROOT" ]; then
  # 如果不存在，则追加到 .bashrc
  echo "source ~/vimrc/root/bashrc" >> ~/.bashrc
	source ~/vimrc/root/bashrc
fi

_make_soft_link() {
	local src=$1
	local target=$2
	if ! [[ -e $target ]]; then
		ln -s $src $target
		if [ $? -eq 0 ]; then
			echo "ln -s $src $target success"
		fi
	else
		echo "File $target exists, skip."	
	fi
}

# nvim
# ln -s $VIMRC_ROOT/.config/nvim ~/.config/nvim
# ln -s $VIMRC_ROOT/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
for f in .vim .ripgreprc .globalrc .tmux.conf .config/ctags .config/lazygit .config/vifm ; do
	_make_soft_link $VIMRC_ROOT/$f ~/$f
done
mkdir -p ~/gadgets
_make_soft_link ~/gadgets ~/.vim/gadgets

echo "Environment variables used:"
echo DOC2="$DOC2"
echo CODE_HOME="$CODE_HOME"
echo "done"
