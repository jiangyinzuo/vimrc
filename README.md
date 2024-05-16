# Vimrc

[wiki](https://github.com/jiangyinzuo/vimrc/wiki)

My personal vimrc configuration files, dotfiles and other scripts. Feel free to contact me or open an issue/PR if you have any questions or suggestions.

## Requirements and Installation

See also `install/README.md`

### Vim/Neovim

#### Vim

vim 9.1+ (full features)  
vim 8.2.4919+ (most of features)  
vim 7.4.629+ (minimal)  

##### Install in Ubuntu

```bash
sudo apt install vim-gtk3
sudo update-alternatives --config vim
update-alternatives  --install /usr/bin/vim vim /usr/local/bin/vim 100
```

Unofficial PPA for Vim: https://launchpad.net/~jonathonf/+archive/ubuntu/vim

##### Build Vim from Source

Run `install/build_vim_from_source.sh` or

```sh
apt install libgtk-3-dev libxt-dev
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes --with-python3-config-dir --enable-gui --with-x
make -j4
make install
```

#### Neovim

neovim 0.10.0+

Source code and executables: https://github.com/neovim/neovim/releases

##### Install from Package

Supported build needs glibc 2.29, while glibc versions of Ubuntu18.04 and CentOS 7.1 are lower than 2.28.

https://github.com/neovim/neovim/blob/nightly/INSTALL.md#install-from-package

[Unstable PPA (requires Ubuntu 20.04+)](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable)

See: https://github.com/neovim/neovim-releases

##### Build from Source

Tested in Ubuntu 18.04, run `install/build_nvim_from_source.sh`

### Node.js (coc.nvim, copilot.vim)

`:h nodejs`

## Setup Environment Variables and Soft Links

```sh
./install/setup.sh
```

Environment variables to setup:  `$DOC2`

## Directory Structure

| Directory Name   | Description                           |
| :--------------- | :------------------------------------ |
| install          | installation scripts                  |
| project_dotfiles | dotfiles for a project                |
| root             | dotfiles and full vim configurations  |
| root/.vim/doc    | my vimdocs                            |
| terminal         | configurations for terminal emulators |
| wsl              | scripts for WSL                       |

### Vimrc Files

**Vim**

- Full vimrc file: `.vim/vimrc`
    - Custom vim configuration file: `~/.vim/config.vim`. See `root/.vim/config.vim.example`.
    - Local vimrc file: `.project.vim`
- Single vimrc file: `.vimrc`
    - Custom vim configuration file `~/config_single_vimrc.vim`
    - Local vimrc file: `.vimrc` (:h 'exrc')

**Neovim**

- init.vim of Neovim: a soft link `root/.config/nvim/init.vim` to `root/.vim/vimrc`, you can run `install/setup.sh` to create it.
    - Custom vim configuration file: `~/.vim/config.vim`. See `root/.vim/config.vim.example`.
    - Local vimrc file: `.project.vim`

## Install Plugins Manually

[vim-plug](https://github.com/junegunn/vim-plug)/[lazy.nvim](https://github.com/folke/lazy.nvim) plugin directory:
`g:vim_plug_dir` (`~/plugged` by default).

[coc.nvim](https://github.com/neoclide/coc.nvim) home: `~/coc`, run `:CocInstall`.  
gadgets home: `~/gadgets`  

You can manually pack them and upload to a remote server:
```
cd ~/plugged
tar -cf plugged.tar fzf LeaderF coc.nvim fzf.vim
```
