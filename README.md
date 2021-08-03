# vimrc

## Requirements

for linux
- vim8.2+, with feature python3
- python3.6+
- node12.12+ (coc.nvim)
- gnu/global6.6+, universal ctags (manually install)
- cscope (https://sourceforge.net/projects/cscope/)
- clangd
- ccls(`snap install ccls`)

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
To add completer, pass arg `--skip-build`
Do not run --rust-completer because it will install the whole rust-toolchain.
If installing java-completer is too slow, modify eclipse URL in `~/.vim/plugged/YouCompleteMe/third_party/ycmd/build.py` to
`https://mirrors.tuna.tsinghua.edu.cn/eclipse/jdtls/snapshots/`

### Coc Install Extensions
`:CocInstall coc-clangd coc-rust-analyzer coc-pyright coc-java coc-java-debug coc-go coc-pairs `

## Code Completion | Jump | Syntax Check
- grep
- ctags + cscope
- gtags
- YouCompleteMe
- LSP(coc + ale)
  - clangd ccls

##
Use Cscope(not recommended)

Create database
[https://stackoverflow.com/questions/11718272/build-cscope-out-files-in-a-separate-directory](https://stackoverflow.com/questions/11718272/build-cscope-out-files-in-a-separate-directory)
```
find . -name '*.c' -o -name '*.h' >  /my/db/cscope.file
cscope -i /my/db/cscope.files
CSCOPE_DB=/my/db/cscope.out; export CSCOPE_DB
```
or
```
cscope -Rbq
```
Find in vim
```
:cs
```
## Generate compile_commands.json
- bear
- compile_db
- ...

## Debug

### Termdebug (gdb)

### vimspector (dap)

#### Installation

If installation is too slow, you can `grep` the github URL in `~/.vim/plugged/vimspector/python3/vimspector/` directory and replace the URL. Then run `./install_gadget.py` script, take golang for example:
```
200~./install_gadget.py --enable-go --sudo
```

#### Setup

Put `.vimspector.json` (for example `example/.vimspector.json`) in project root folder.

#### Debugging Java

For example, we run the JDWP server at 5005

```
javac -g Hello.java
java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y Hello
```
Then press `<leader><F5>` or `<F1>` to launch vimspector.

#### Useful Commands
`:VimspectorEval`: evaluate expression

## Code Format
- json(run `sudo apt install jq` before): `:%!jq .`

### Auto Use/Import in Rust/Java
It is supported by coc.nvim: `<leader>a`
