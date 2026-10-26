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
- neovim 0.13.0-dev+
    - plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)
        - Git 2.19.0+

## Installation

See [install/README.md](./install/README.md).

## File Structure

| File Name         | Description                           |
|:------------------|:--------------------------------------|
| install           | installation scripts                  |
| network           | network-related scripts               |
| project_files     | config files for local project        |
| root              | dotfiles                              |
| root/.config/nvim | neovim configurations                 |
| root/.vim/vimrc   | full vimrc file                       |
| root/.vim/doc     | my help files                         |
| terminal          | configurations for terminal emulators |
| wsl               | scripts for WSL, `:h wsl.txt`         |

### Docker Mirror Benchmark

Run `./test-docker-mirror.py` with Python 3 to compare GHCR and the Nanjing
University mirror for `vectorize-io/hindsight:latest` (Linux amd64). No Docker
daemon or third-party packages are required. Each host downloads at most 8 MiB
from the largest layer; results include timings, throughput, and image/layer
digests. This is a sample benchmark, not a full image pull or signature check.

Use `./test-docker-mirror.py --help` for repository, tag, architecture, timeout,
and custom registry host options. Failed hosts or differing digests produce a
nonzero exit status.

### Vimrc Files

- `root/.vim/vimrc`
    - For Neovim: init.vim(`root/.config/nvim/init.vim`) is a soft link to `root/.vim/vimrc`, you can run `install/setup.sh` to create it.
- Custom vim configuration file: `~/.vim/config.vim` (Vim / Neovim) and `~/.config/nvim/lua/config.lua` (Neovim). See `root/.vim/config.vim.example`.

### Python LSP (Neovim)

Use `:PythonLspSwitch pyrefly`, `:PythonLspSwitch ty`,
`:PythonLspSwitch pyright`, or `:PythonLspSwitch basedpyright` to switch the
Python language server in the running Neovim instance, including already-open
Python buffers. Without an argument, `:PythonLspSwitch` opens a selection list.
The server must already be installed and available on `PATH`.

The selection is saved as `g:python_lsp` at the end of `~/.vim/config.vim`
and used on subsequent starts. Other configuration is preserved; save any
unsaved edits to that file before switching. Other language servers and
formatters are not changed.
