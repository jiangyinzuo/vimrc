set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if exists("g:vscode")
	source ~/.vim/vimrc
else
	let g:nvim_compatibility_with_vim = 0
	source ~/.vim/vimrc
	if ! g:nvim_compatibility_with_vim
		runtime setup.lua
	end
end
