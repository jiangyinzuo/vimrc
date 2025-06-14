# Vimrc

<a href="https://dotfyle.com/jiangyinzuo/vimrc"><img src="https://dotfyle.com/jiangyinzuo/vimrc/badges/plugin-manager?style=for-the-badge" /></a>

[wiki](https://github.com/jiangyinzuo/vimrc/wiki)

My personal Vim/Neovim configuration files, dotfiles, docs and other scripts.

## Requirements

OS: Linux, WSL

Vim/Neovim requirements:

- vim 9.1+ (full features)
- vim 7.4.629+ (minimal, tested in CentOS 7)
    - plugin manager: [vim-plug](https://github.com/junegunn/vim-plug)
- neovim 0.11.0+
    - plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)
        - Git 2.19.0+

## Installation

See [install/README.md](./install/README.md).

## File Structure

| File Name         | Description                           |
|:------------------|:--------------------------------------|
| install           | installation scripts                  |
| project_files     | config files for local project        |
| root              | dotfiles                              |
| root/.config/nvim | neovim configurations                 |
| root/.vim/vimrc   | full vimrc file                       |
| .vimrc            | single vimrc file                     |
| root/.vim/doc     | my help files                         |
| terminal          | configurations for terminal emulators |
| wsl               | scripts for WSL, `:h wsl.txt`         |

### Vimrc Files

**Vim**

- Full vimrc file: `.vim/vimrc`
    - Custom vim configuration file: `~/.vim/config.vim`. See `root/.vim/config.vim.example`.
    - Local project vimrc file: `.project.vim`
- Single vimrc file: `.vimrc`
    - Custom vim configuration file `~/config_single_vimrc.vim`
    - Local project vimrc file: `.vimrc` (:h 'exrc')

**Neovim**

init.vim(`root/.config/nvim/init.vim`) is a soft link to `root/.vim/vimrc`, you can run `install/setup.sh` to create it.

- Custom vim configuration file: `~/.vim/config.vim`. See `root/.vim/config.vim.example`.
- Local project vimrc file: `.project.vim`
