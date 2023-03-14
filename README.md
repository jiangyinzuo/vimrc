# Vimrc

Requirements: vim 8.2.4919(full features), vim 7.4(.vimrc)  

Ubuntu22.04下安装`sudo apt install vim-gtk3`，可以尝试设置`sudo update-alternatives --config vim` 
安装Neovim：` sudo apt install neovim python3-pynvim`  
Neovim WSL使用系统clipboard：https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl

**Vim编译选项**  
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes

`:CocInstall`后，连同nodejs打包给docker容器用
```
tar -cvf myvim.tar node root
docker build -t myvim:1 .
```

手动安装vim插件和coc插件的安装目录.vim/plugged和.vim/coc文件夹  

## 初始化

```sh
./init.sh
```

## 其它命令行工具

Ubuntu22.04下均可通过apt安装  

目录树: tree  
查找: find -> fd  
模糊查找: fzf  
内容搜索: grep -> ripgrep  
https://jdhao.github.io/2020/02/16/ripgrep_cheat_sheet/  

下载: wget -> axel  
git终端: lazygit  
Linux文本处理: awk, sed, cut  
cat -> bat，Ubuntu下的命令叫batcat。能让fzf.vim的preview window变快。  
```
sudo apt install bat
batcat --version
```
### LSP
c++: clangd  
go: gopls（可以通过vim-go下载后，配置环境变量）  

## WSL2

```
sudo apt install wslu
```

## 远程开发环境对比

**本地开发环境+远程文件系统：sshfs**
适用于本地有开发环境，远程没有搭开发环境的场景

**vscode+neovim插件 ssh remote**
优点：无需在服务器安装高版本(neo)vim、无需OSC就可以复制粘贴远程服务器上的文本，方便查看渲染后的pdf/网页/markdown
缺点：面对跳板机环境不方便

**(neo)vim**
优点：在跳板机环境、临时服务器环境（无插件配置）下比较方便
缺点：在低版本操作系统中编译安装高版本(neo)vim和插件比较麻烦，不用sshfs时，查看渲染后的pdf/网页/markdown比较麻烦
