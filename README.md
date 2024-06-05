# Vimrc

[wiki](https://github.com/jiangyinzuo/vimrc/wiki)

My personal vim/neovim configuration files, dotfiles and other scripts. Feel free to contact me or open an issue/PR if you have any questions or suggestions.

> "User-friendly," "universal," and "easy to use" form the impossible trinity of tools.
>
> 好用，通用，易用，是工具的不可能三角。

## Requirements and Installation

Vim/Neovim requirements:

- vim 9.1+ (full features)
- vim 8.2.4919+ (most of features)
- vim 7.4.629+ (minimal)
- neovim 0.11.0+

See [install/README.md](./install/README.md) for more details.

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
