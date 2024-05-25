#!/bin/bash

UBUNTU_CODE_NAME=$(lsb_release -c | cut -f2)
UBUNTU_VERSION=$(lsb_release -r | cut -f2)

prompt=""

function install_tmux() {
	# Ubuntu18.04默认安装tmux2.6
	# tmux2.6中，使用fzf的CTRL-R快捷键会卡死，请手动运行 cd ~/vimrc && ./install/build_tmux.sh安装
	if [[ $UBUNTU_VERSION == "18.04" ]]; then
		./install/build_tmux.sh
	else
		sudo apt-get install -y tmux
	fi
}

function install_nvim() {
	if [[ $UBUNTU_VERSION == "18.04" || $UBUNTU_VERSION == "20.04" ]]; then
		./install/build_nvim.sh $NVIM_COMMIT
	else
		sudo add-apt-repository ppa:neovim-ppa/unstable
		sudo apt-get install -y neovim
		pip3 install neovim
	fi
}

function install_llvm() {
	local LLVM_URL=http://apt.llvm.org

	# https://apt.llvm.org/
	wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
	sudo touch /etc/apt/sources.list.d/llvm.list
	sudo chmod 666 /etc/apt/sources.list.d/llvm.list
	sudo cat > /etc/apt/sources.list.d/llvm.list << EOF
deb ${LLVM_URL}/$UBUNTU_CODE_NAME/ llvm-toolchain-$UBUNTU_CODE_NAME${LLVM_VERSION} main
deb-src ${LLVM_URL}/$UBUNTU_CODE_NAME/ llvm-toolchain-$UBUNTU_CODE_NAME${LLVM_VERSION} main
EOF
	sudo apt-get update
	sudo apt-get install -y clangd${LLVM_VERSION} clang-tidy${LLVM_VERSION} clang-format${LLVM_VERSION} clang${LLVM_VERSION}
}

function install_rg_fd() {
	if [[ $UBUNTU_VERSION == "18.04" ]]; then
	prompt=$prompt"
		=== ripgrep ===
		请前往 https://github.com/BurntSushi/ripgrep/releases 下载对应版本的 ripgrep deb package (14.1.0可用)
		运行 sudo dpkg -i <package_name>.deb 安装 ripgrep

		=== fd ===
		请前往 https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-musl_9.0.0_amd64.deb 下载对应musl版本的 fd deb package, musl代表不依赖 glibc (9.0.0可用)
		运行 sudo dpkg -i <package_name>.deb 安装 fd

	"
	else
		# ripgrep:
		# any-jump.vim cpp需要PCRE2 feature
		# Ubuntu18.04 需要前往https://github.com/BurntSushi/ripgrep/releases
		# 下载.deb文件(ripgrep_14.1.0-1_amd64.deb 可以用)
		sudo apt-get install -y ripgrep fd-find

		# 输出结果
		if [ "$path_found" = false ]; then
			echo "$path_to_check is in \$PATH"
		else
			echo "$path_to_check is not in \$PATH"
		fi

		ln -s $(which fdfind) $HOME/.local/bin/fd
		prompt=$prompt"
		=== fd ===
		请检查 $HOME/.local/bin/fd 是否在 \$PATH 中
		"
	fi
}

function install_other_apt_packages() {
	# apt install -y golang
	# Leaderf needs python3-dev and python3-distutils
	# wamerican: American English字典文件，安装后位于/usr/share/dict/american-english, 用于vim dictionary
	# wordnet: nvim cmp dictionary 可以用wordnet解释单词
	sudo apt-get install -y curl tree bat git cmake sqlformat python3-dev python3-distutils wamerican wordnet

	# ripgrep-all（master分支）
	# See: https://github.com/phiresky/ripgrep-all/issues/113
	# apt install ripgrep pandoc poppler-utils ffmpeg
}

_cargo_installed=false
function install_cargo() {
	if [ "$_cargo_installed" = false ]; then
		_cargo_installed=true
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	fi
}

function install_git_delta() {
	install_cargo
	prompt=$prompt"
		=== git-delta ===
		source ~/.bashrc
		cargo install git-delta

	"
}

function install_vim() {
	# install vim-gtk3
	# apt-get install -y libgtk-3-dev libxt-dev vim-gtk3
	# sudo update-alternatives --config vim
	# update-alternatives  --install /usr/bin/vim vim /usr/local/bin/vim 100
	sudo apt-get -y install libgtk-3-dev libxt-dev
	./install/build_vim.sh $VIM_COMMIT
}

function install_nvm() {
	# install nodejs
	# alternative: n
	# Ubuntu18.04安装node20的一种方案: https://github.com/nodesource/distributions/issues/1392#issuecomment-1815887430
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	prompt=$prompt"
		=== Node.js ===
		source ~/.bashrc
		nvm install --lts

	"
}

_go_installged=false
function install_go() {
	if [ "$_go_installed" = false ]; then
		_go_installed=true
		sudo snap install go --classic
		prompt=$prompt"
		=== Go ===
		必须确保GOPATH/bin在环境变量，保证gopls能找到。
		不要用apt安装gopls/delve，该版本为unknown，影响go.nvim插件解析。

		"
	fi
}

function install_gvm() {
	install_go
	sudo apt-get -y install curl git mercurial make binutils bison gcc build-essential
	bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
	prompt=$prompt"
		=== GVM ===
		source ~/.bashrc
		gvm install go1.16.3
		gvm use go1.16.3

	"
}

set -v

install_tmux
# option: $NVIM_COMMIT
install_nvim
LLVM_VERSION=${LLVM_VERSION:="-18"}
install_llvm
install_rg_fd
install_other_apt_packages
install_git_delta
# option: $VIM_COMMIT
# install_vim
install_nvm
# install_go
# install_gvm
# ./install/python.sh

echo "$prompt"
