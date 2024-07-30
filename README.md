# Vimrc

[wiki](https://github.com/jiangyinzuo/vimrc/wiki)

My personal vim/neovim configuration files, dotfiles, docs and other scripts.

## Requirements and Installation

OS: Linux, WSL

Vim/Neovim requirements:

- vim 9.1+ (full features)
- vim 7.4.629+ (minimal)
- neovim 0.11.0+

See [install/README.md](./install/README.md) for more details.

## File Structure

| File Name         | Description                           |
| :---------------- | :------------------------------------ |
| install           | installation scripts                  |
| project_files     | config files for local project        |
| root              | dotfiles                              |
| root/.config/nvim | neovim configurations                 |
| root/.vim/vimrc   | full vimrc file                       |
| root/.vim/doc     | my vimdocs                            |
| terminal          | configurations for terminal emulators |
| wsl               | scripts for WSL                       |

### Vimrc Files

**Vim**

- Full vimrc file: `.vim/vimrc`
    - Custom vim configuration file: `~/.vim/config.vim`. See `root/.vim/config.vim.example`.
    - Local project vimrc file: `.project.vim`
    - [vim-plug](https://github.com/junegunn/vim-plug) as plugin manager
- Single vimrc file: `.vimrc`
    - Custom vim configuration file `~/config_single_vimrc.vim`
    - Local project vimrc file: `.vimrc` (:h 'exrc')

**Neovim**

init.vim(`root/.config/nvim/init.vim`) is a soft link to `root/.vim/vimrc`, you can run `install/setup.sh` to create it.

- Custom vim configuration file: `~/.vim/config.vim`. See `root/.vim/config.vim.example`.
- Local project vimrc file: `.project.vim`
- [lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager.
