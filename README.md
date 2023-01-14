c++使用clangd lsp。
go使用gopls lsp，可以通过vim-go下载后，配置环境变量

vim编译选项
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes

`:CocInstall`后，连同nodejs打包给docker容器用
```
tar -cvf myvim.tar node root
docker build -t myvim:1 .
```

创建软链接：
```
ln -s vimrc/root/.vimrc .vimrc
ln -s vimrc/root/vimrc.d vimrc.d
ln -s vimrc/root/.vim .vim
```
