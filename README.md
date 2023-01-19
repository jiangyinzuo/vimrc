
vim编译选项
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes

`:CocInstall`后，连同nodejs打包给docker容器用
```
tar -cvf myvim.tar node root
docker build -t myvim:1 .
```

## 初始化

创建软链接：
```sh
ln -s vimrc/root/.vimrc .vimrc
ln -s vimrc/root/vimrc.d vimrc.d
ln -s vimrc/root/.vim .vim
```

shell alias:
```sh
source vimrc/root/alias.sh
```

## 命令行工具

查找: find -> fd（还没用过）
模糊查找: fzf
内容搜索: grep -> ripgrep
下载: wget -> axel
git终端: lazygit

### LSP
c++: clangd
go: gopls（可以通过vim-go下载后，配置环境变量）
