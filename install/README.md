# Installation

For Ubuntu users, run
```bash
./install/ubuntu.sh
```

Setup environment variables and soft links
```bash
./install/setup.sh
```

Setup `$DOC2` manually (optional)

Run `sync-scripts.sh` and `:PlugUpgrade` to sync scripts (optional).

## Manual Installation Hints

### Vim

Unofficial PPA for Vim: https://launchpad.net/~jonathonf/+archive/ubuntu/vim

**Build from Source**: `install/build_vim.sh`

### Neovim

Source code and executables: https://github.com/neovim/neovim/releases

**Install from Package**

Supported build needs glibc 2.29, while glibc versions of Ubuntu18.04 and CentOS 7.1 are lower than 2.28.

https://github.com/neovim/neovim/blob/nightly/INSTALL.md#install-from-package

[Unstable PPA (requires Ubuntu 20.04+)](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable)

See: https://github.com/neovim/neovim-releases

**Build from Source**: `install/build_nvim.sh`

### Node.js

coc.nvim and copilot.vim depend on Node.js.

`:h nodejs`

### Command Line Tools

We install fzf via vim plugin.

### Install Plugins Manually

[vim-plug](https://github.com/junegunn/vim-plug)/[lazy.nvim](https://github.com/folke/lazy.nvim) plugin directory:
`g:vim_plug_dir` (`~/plugged` by default).

[coc.nvim](https://github.com/neoclide/coc.nvim) home: `~/coc`, run `:CocInstall`.  
gadgets home: `~/gadgets`  

You can manually pack them and upload to a remote server:
```
cd ~/plugged
tar -cf plugged.tar fzf LeaderF coc.nvim fzf.vim
```
