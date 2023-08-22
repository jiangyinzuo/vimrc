#/bin/bash

if [[ $VIMRC_ROOT == '' ]]; then
	echo '$VIMRC_ROOT is empty'
	exit 1
fi

ln -s $VIMRC_ROOT/.vim ~/.vim
ln -s $VIMRC_ROOT/.ripgreprc ~/.ripgreprc
ln -s $VIMRC_ROOT/.globalrc ~/.globalrc
ln -s $VIMRC_ROOT/.tmux.conf ~/.tmux.conf
ln -s $VIMRC_ROOT/.config/ctags ~/.config/ctags
ln -s $VIMRC_ROOT/.config/lazygit ~/.config/lazygit

# nvim
# ln -s $VIMRC_ROOT/.config/nvim ~/.config/nvim
# ln -s $VIMRC_ROOT/.vim/coc-settings.json ~/.config/nvim/coc-settings.json

# ln -s $VIMRC_ROOT/.config/lazygit ~/.config/lazygit

echo "Environment variables used:"
echo DOC2="$DOC2"
echo CODE_HOME="$CODE_HOME"
