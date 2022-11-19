c++使用clangd lsp。
go使用gopls lsp，可以通过vim-go下载后，配置环境变量

vim编译选项
./configure --with-features=huge --enable-fontset=yes --enable-cscope=yes --enable-multibyte --enable-python3interp=yes

打包给docker用
```
tar -cvf myvim.tar node root
docker build -t myvim:1 .
```
