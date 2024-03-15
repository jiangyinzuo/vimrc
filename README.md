# Vimrc

## Requirements

### Vim/Neovim/VSCode Neovim

#### Vim

vim 9.1 (full features)  
vim 8.2.4919 (most of features)  
vim 7.4.629 (minimal)  

```bash
sudo apt install vim-gtk3
sudo update-alternatives --config vim
update-alternatives  --install /usr/bin/vim vim /usr/local/bin/vim 100
```

Unofficial PPA for Vim: https://launchpad.net/~jonathonf/+archive/ubuntu/vim

**Build Vim from Source**
```sh
apt install libgtk-3-dev libxt-dev
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes --with-python3-config-dir --enable-gui --with-x
make -j4
make install
```

See also: `install/build_vim_from_source.sh`

#### Neovim

neovim 0.9.5+

Source code and executables: https://github.com/neovim/neovim/releases

##### Install from Package

Supported build needs glibc 2.29, while glibc versions of Ubuntu18.04 and CentOS 7.1 are lower than 2.28

https://github.com/neovim/neovim/blob/nightly/INSTALL.md#install-from-package

Unstable PPA (needs Ubuntu 20.04+):

https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable

See: https://github.com/neovim/neovim-releases

##### Build from Source

tested in Ubuntu 18.04

See `install/build_nvim_from_source.sh`

##### Python3
```bash
sudo apt install neovim python3-pynvim
pip3 install neovim
```

#### VSCode Neovim

TODO

### Node.js (coc.nvim, copilot.vim)

`:h nodejs`

## Setup Environment Variables and Soft Links

```sh
./install/setup.sh
```

Environment variables to setup:  `$DOC2` `$CODE_HOME`

## Vimrc

- Full vimrc file: `.vim/vimrc`
    - Default configurations: see header of `.vim/vimrc`
    - Custom vim configuration file: `~/.vim/config.vim`
    - Local vimrc file: `.project.vim`
- Single vimrc file: `.vimrc`
    - Custom vim configuration file `~/config_single_vimrc.vim`
    - Local vimrc file: `.vimrc` (:h 'exrc')

## Install Plugins Manually

vim-plug home: `~/plugged`, run `:PlugInstall`. `PlugInstall` can also update helptags for plugins.  
coc home: `~/coc`, run `:CocInstall`.  
gadgets home: `~/gadgets`  

You can manually (un)pack them like this:
```
cd ~/plugged
tar -cf plugged.tar fzf LeaderF coc.nvim fzf.vim
```
