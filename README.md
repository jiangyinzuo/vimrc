# Vimrc

Requirements: vim 8.2.4919(most of features), vim 7.4(minimal)  

Ubuntu22.04下安装`sudo apt install vim-gtk3`，可以尝试设置`sudo update-alternatives --config vim`  
```
update-alternatives  --install /usr/bin/vim vim /usr/local/bin/vim 100
```
安装Neovim：` sudo apt install neovim python3-pynvim`  
`pip3 install neovim`  

Neovim WSL使用系统clipboard：https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl

**Vim编译选项**
```sh
apt install libgtk-3-dev libxt-dev
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes --enable-gui --with-x
```

## 安装

需要设置的不能为空的环境变量: `$DOC2` `$CODE_HOME`
```sh
# 在当前进程执行，让export环境变量直接生效
. setup.sh
```
默认配置: See `vimrc`  
修改vimrc配置文件: `.vim/config.vim`  
打包coc/plugged/gadgets: See `make-tar`


## 索引查找

### 基于文本匹配的查找
ripgrep, grep  
[any-jump.vim](https://github.com/pechorin/any-jump.vim)在不同的位置:AnyJump同一个word，结果会不一样。
在注释处:AnyJump可能只会找到注释；在cpp类的方法实现处:AnyJump才会跳到类的定义。
cpp需要rg with PCRE2 support

### 基于tag符号的索引/补全

see root/.vim/doc/tags.txt

### 基于LSP的索引/补全

coc.vim  
c++: clangd  
go: gopls（可以通过vim-go下载后，配置环境变量）  
ocaml: ocaml-lsp(不直接通过`opam user-setup install`使用merlin)  
...

### 基于AI的补全

Github Copilot  
[tabnine](tabnine.com)(vscode, jetbrains)  
codegeex  

## WSL2

See `wsl`
打开网页：xdg-open index.html

## 远程开发环境对比

sourcegraph: 在线代码阅读  

**本地开发环境+远程文件系统：sshfs**
适用于本地有开发环境，远程没有搭开发环境的场景

**vscode+neovim插件 ssh remote**
优点：无需在服务器安装高版本(neo)vim、无需OSC就可以复制粘贴远程服务器上的文本，方便查看渲染后的pdf/网页/markdown  
缺点：面对跳板机环境不方便  
案例：  
《智能计算系统》课程实验，Ubuntu16.04 vim7.4 python2.7 docker容器，容器内有许多课程独有的基于深度学习处理器（DLP）的依赖，必须用它的docker容器开发环境。不方便编译安装vim8。SSH比较卡。

**(neo)vim**
优点：在跳板机环境、临时服务器环境（无插件配置）下比较方便  
缺点：在低版本操作系统中编译安装高版本(neo)vim和插件比较麻烦，不用sshfs时，查看渲染后的pdf/网页/markdown比较麻烦，ssh网速慢的时候卡顿严重，某些创业公司的新应用可能优先提供vscode官方插件，不提供vim插件。

Jetbrains Fleet

cursor.so

[distant](https://github.com/chipsenkbeil/distant)

## 终端模拟器
wezterm

