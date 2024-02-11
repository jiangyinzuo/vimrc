# Vimrc

## Requirements

### Vim or Neovim

**Vim (recommended)**

vim 9 (full features)  
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

**Neovim (unstable)**

neovim 0.9.0+ (need glibc 2.28, while glibc versions of Ubuntu18.04 and CentOS 7.1 are lower than 2.28)

[Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu)  
```bash
sudo apt install neovim python3-pynvim
pip3 install neovim
```

### Node.js (coc.nvim)

- Ubuntu18.04: https://github.com/nodesource/distributions#debian-and-ubuntu-based-distributions
- https://github.com/tj/n
- https://github.com/nvm-sh/nvm

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
