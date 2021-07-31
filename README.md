# vimrc

## Requirements

for linux
- vim8.2+, with feature python3
- python3.6+
- node12.12+
- gnu/global6.6+
- clangd

## Setup

```shell
# for Defx
pip3 install --user pynvim
pip install pygments
./setup_linux.sh
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
