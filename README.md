# Vimrc

Ubuntu22.04下安装`sudo apt install vim-gtk3`

Vim编译选项
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes

`:CocInstall`后，连同nodejs打包给docker容器用
```
tar -cvf myvim.tar node root
docker build -t myvim:1 .
```

## 初始化

```sh
ln -s vimrc/root/.vimrc .vimrc
ln -s vimrc/root/vimrc.d vimrc.d
ln -s vimrc/root/.vim .vim
source vimrc/root/bashrc
```

## 其它命令行工具

查找: find -> fd（还没用过）
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
