# vimrc

## Requirements

for linux
- vim8.2+, with feature python3
- python3.6+
- node12.12+
- gnu/global6.6+, universal ctags (manually install)
- clangd

## Setup

```shell
# for Defx
pip3 install --user pynvim
# for tags
pip install pygments
./setup_linux.sh
```

### Install YouCompleteMe
```shell
cd ~/.vim/plugged/YouCompleteMe
python3 install.py --go-completer
```

### Coc Install Language Server
`:CocInstall coc-clangd`

## Code Completion | Jump | Syntax Check
- grep
- ctags + cscope
- gtags
- YouCompleteMe
- LSP(coc + ale)
  - clangd ccls

## Generate compile_commands.json
- bear
- compile_db
- ...

## Debug
- vimspector

## Code Format
- json(run `sudo apt install jq` before): `:%!jq .`

### Auto Use/Import in Rust/Java
It is supported by coc.nvim: `<leader>a`
