set -e

_uninstall_current_version() {
	if [[ -z $prev_vim_version ]]; then
		echo "No previous Vim version found."
		return
	fi
	pushd vim-$prev_vim_version
	sudo make uninstall
	popd
	rm VIM_VERSION
}

_install_vim() {
	# get and validate vim version
	local vim_version="$1"
	if [[ -z $vim_version ]]; then
		echo "Get the latest Vim version..."
		vim_version=$(curl -s https://api.github.com/repos/vim/vim/tags | jq -r '.[0].name')
		vim_version=${vim_version#v}
	fi
	echo "Build Vim $vim_version..."

	pattern="^[0-9]+\.[0-9]+\.[0-9]+$"
	if [[ ! $vim_version =~ $pattern ]]; then
		echo "Usage:"
		echo "$0 u|uninstall"
		echo "$0 [Vim version (e.g. 9.1.0004)]"
		exit 1
	fi

	if [[ $prev_vim_version == $vim_version ]]; then
		echo "Vim $vim_version already installed."
		exit 0
	fi
	_uninstall_current_version
	
	local vimtar_file=v${vim_version}.tar.gz
	# clean vim source code files
	rm -rf vim*
	for old_vimter_file in v*.tar.gz; do
		if [[ $old_vimter_file != $vimtar_file ]]; then
			rm $old_vimter_file
		fi
	done

	# download vim source code
	if [ ! -f $vimtar_file ]; then
		wget https://github.com/vim/vim/archive/refs/tags/${vimtar_file}
	fi
	
	tar -xf $vimtar_file
	pushd vim-${vim_version}
	./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes --with-python3-config-dir --enable-gui --with-x
	make -j4
	sudo make install
	popd
	
	echo $vim_version > VIM_VERSION
}

# init build dir
if [ ! -d ~/vimrc ]; then
	echo "No vimrc dir found."
	exit 1
fi
build_dir=~/vimrc/build
mkdir -p $build_dir
cd $build_dir
touch VIM_VERSION
prev_vim_version=$(cat VIM_VERSION)

case $1 in
	u|uninstall)
		_uninstall_current_version
		;;
	*)
		_install_vim $1
		;;
esac
