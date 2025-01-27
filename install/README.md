# Installation

1. Install dependencies:
```bash
# Ubuntu
sudo -E ./install/ubuntu.sh
# CentOS7
sudo yum install centos-release-scl
sudo yum install devtoolset-11
scl enable devtoolset-11
sudo -E ./install/centos7.sh
```

2. Setup environment variables and soft links
```bash
./install/setup.sh
```

**optional:**

- Setup `$DOC2` manually
- Run `sync-scripts.sh` and `:PlugUpgrade` to sync scripts
- Reinstall `lazy.nvim` manually

## Vim

Unofficial PPA for Vim: https://launchpad.net/~jonathonf/+archive/ubuntu/vim

### Build from Source

```bash
sudo -E install/build_vim.sh
```

### Install Vim from Conda-Forge

https://github.com/conda-forge/vim-feedstock

## Neovim

Source code and executables: https://github.com/neovim/neovim/releases

### Install from Package

Supported build needs glibc 2.29, while glibc versions of Ubuntu18.04 and CentOS 7.1 are lower than 2.28.

https://github.com/neovim/neovim/blob/nightly/INSTALL.md#install-from-package

[Unstable PPA (requires Ubuntu 20.04+)](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable)

See also: https://github.com/neovim/neovim-releases

### Install via Snap in CentOS 7

https://snapcraft.io/nvim

```bash
sudo yum install epel-release
sudo yum install snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
# edge: nightly version
sudo snap install nvim --classic --edge
# update
sudo snap refresh nvim --edge --classic
```

Reference: https://gist.github.com/backroot/add72227c11759615207cbae79362287

### Build from Source

```bash
sudo -E install/build_nvim.sh
```

## Node.js

coc.nvim and copilot.vim depend on Node.js.

`:h nodejs`

## Command Line Tools

We install fzf via vim plugin.

## Install Plugins Manually

[vim-plug](https://github.com/junegunn/vim-plug)/[lazy.nvim](https://github.com/folke/lazy.nvim) plugin directory:
`g:vim_plug_dir` (`~/plugged` by default).

[coc.nvim](https://github.com/neoclide/coc.nvim) home: `~/coc`, run `:CocInstall`.

[vimspector](https://github.com/puremourning/vimspector) gadgets home: `~/gadgets`

You can manually pack them and upload to a remote server:
```
cd ~/plugged
tar -cf plugged.tar fzf LeaderF coc.nvim fzf.vim
```
