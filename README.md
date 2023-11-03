# Vimrc

## Vim Requirements

**Vim (recommended)**

vim 9 (full features)  
vim 8.2.4919 (most of features)  
vim 7.4 (minimal)  

**Neovim (unstable)**

neovim 0.8.2+  

## How to Intall

### Ubuntu

Vim  
```bash
sudo apt install vim-gtk3
sudo update-alternatives --config vim
update-alternatives  --install /usr/bin/vim vim /usr/local/bin/vim 100
```

[Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu)  
```bash
sudo apt install neovim python3-pynvim
pip3 install neovim
```

### Build Vim from Source

```sh
apt install libgtk-3-dev libxt-dev
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes --enable-gui --with-x
```

## Setup Environment Variables and Soft Links

```sh
./setup.sh
```

Environment variables to setup:  `$DOC2` `$CODE_HOME`

## Vim Configurations

Default configurations: see header of `.vim/vimrc`  
Custom vim configuration file: `.vim/config.vim`  

## Install Plugins

vim-plug home: `~/plugged`  
coc home: `~/coc`  
gadgets home: `~/gadgets`  

You can manually unpack plugins to these home directories.
