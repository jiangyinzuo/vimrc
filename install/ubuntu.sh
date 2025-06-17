#!/bin/bash
# vim: set noet:

set -e;

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $SCRIPT_DIR/rust-toolchain.sh

if command -v sudo >/dev/null 2>&1; then
	# sudo 命令存在，使用sudo执行命令
	SUDO=sudo
else
	# sudo 命令不存在，直接执行命令
	SUDO=
fi

$SUDO apt-get update
$SUDO apt-get install -y lsb-release software-properties-common python3-pip

UBUNTU_CODE_NAME=$(lsb_release -c | cut -f2)
UBUNTU_VERSION=$(lsb_release -r | cut -f2)

prompt=""

function install_tmux() {
	# Ubuntu18.04默认安装tmux2.6
	# tmux2.6中，使用fzf的CTRL-R快捷键会卡死，请手动运行 cd ~/vimrc && ./install/build_tmux.sh安装
	if [[ $UBUNTU_VERSION == "18.04" ]]; then
		./install/build_tmux.sh
	else
		$SUDO apt-get install -y tmux
	fi
}

function install_nvim() {
	if [[ $UBUNTU_VERSION == "18.04" ]]; then
		./install/build_nvim.sh $NVIM_COMMIT
	else
		$SUDO add-apt-repository ppa:neovim-ppa/unstable
		$SUDO apt-get install -y neovim
		pip3 install neovim
	fi
}

function install_llvm() {
	local LLVM_URL=http://apt.llvm.org

	# https://apt.llvm.org/
	wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
	touch /etc/apt/sources.list.d/llvm.list
	chmod 666 /etc/apt/sources.list.d/llvm.list
	cat > /etc/apt/sources.list.d/llvm.list << EOF
deb ${LLVM_URL}/$UBUNTU_CODE_NAME/ llvm-toolchain-$UBUNTU_CODE_NAME${LLVM_VERSION} main
deb-src ${LLVM_URL}/$UBUNTU_CODE_NAME/ llvm-toolchain-$UBUNTU_CODE_NAME${LLVM_VERSION} main
EOF
	$SUDO apt-get update
	$SUDO apt-get install -y clangd${LLVM_VERSION} clang-tidy${LLVM_VERSION} clang-format${LLVM_VERSION} clang${LLVM_VERSION}
}

function install_rg() {
	if [[ $UBUNTU_VERSION == "18.04" || $UBUNTU_VERSION == "20.04" ]]; then
		# ripgrep:
		# any-jump.vim cpp需要PCRE2 feature
		# Ubuntu18.04 需要前往https://github.com/BurntSushi/ripgrep/releases
		# 下载.deb文件(ripgrep_14.1.0-1_amd64.deb 可以用)
		mkdir -p build
		wget --directory-prefix build https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
		$SUDO dpkg -i build/ripgrep_14.1.0-1_amd64.deb
	else
		$SUDO apt-get install -y ripgrep
	fi
}

function install_fd() {
	if [[ $UBUNTU_VERSION == "18.04" ]]; then
	prompt=$prompt"
		=== fd ===
		请前往 https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-musl_9.0.0_amd64.deb 下载对应musl版本的 fd deb package, musl代表不依赖 glibc (9.0.0可用)
		运行 dpkg -i <package_name>.deb 安装 fd
	"
	else
		$SUDO apt-get install -y fd-find
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
	# wamerican: American English字典文件，安装后位于/usr/share/dict/words, 用于vim dictionary
	# wordnet: nvim cmp dictionary 可以用wordnet解释单词
	$SUDO apt-get install -y curl less tree bd bat git cmake sqlformat python3-dev python3-distutils wamerican wordnet shfmt

	# ripgrep-all（master分支）
	# See: https://github.com/phiresky/ripgrep-all/issues/113
	# apt install ripgrep pandoc poppler-utils ffmpeg
}

function install_vim() {
	# install vim-gtk3
	# apt-get install -y libgtk-3-dev libxt-dev vim-gtk3
	# update-alternatives --config vim
	# update-alternatives  --install /usr/bin/vim vim /usr/local/bin/vim 100
	$SUDO apt-get -y install libgtk-3-dev libxt-dev
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
		$SUDO snap install go --classic
		prompt=$prompt"
		=== Go ===
		必须确保GOPATH/bin在环境变量，保证gopls能找到。
		不要用apt安装gopls/delve，该版本为unknown，影响go.nvim插件解析。

		"
	fi
}

function install_gvm() {
	install_go
	$SUDO apt-get -y install curl git mercurial make binutils bison gcc build-essential
	bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
	prompt=$prompt"
		=== GVM ===
		source ~/.bashrc
		gvm install go1.16.3
		gvm use go1.16.3

	"
}

set -v

# install_tmux
# snap install --classic zellij

# option: $NVIM_COMMIT
install_nvim
# LLVM_VERSION=${LLVM_VERSION:="-18"}
# install_llvm
install_rg
install_fd
install_other_apt_packages
install_git_delta
# option: $VIM_COMMIT
# install_vim
install_nvm
# tree-sitter cli
npm install tree-sitter-cli
# install_go
# install_gvm

# cmake and python lsp
# pip3 install cmake-language-server cmakelang basedpyright black -U
# lua
# cargo install stylua

# 加上双引号才能echo换行符
echo "$prompt"
