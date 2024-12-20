#!/bin/bash
# LLVM Project
# remove llvm.vim since vim-patch 9.1.0866
for vimscript in mir.vim tablegen.vim ; do
	( wget --output-document root/.vim/ftplugin/$vimscript https://github.com/llvm/llvm-project/raw/main/llvm/utils/vim/ftplugin/$vimscript )
done
# remove llvm.vim since vim-patch 9.1.0866
for vimscript in mir.vim tablegen.vim llvm-lit.vim ; do
	( wget --output-document root/.vim/ftdetect/$vimscript https://github.com/llvm/llvm-project/raw/main/llvm/utils/vim/ftdetect/$vimscript )
done
for vimscript in llvm.vim machine-ir.vim mir.vim tablegen.vim ; do
	( wget --output-document root/.vim/syntax/$vimscript https://github.com/llvm/llvm-project/raw/main/llvm/utils/vim/syntax/$vimscript )
done
for vimscript in llvm.vim ; do
	( wget --output-document root/.vim/indent/$vimscript https://github.com/llvm/llvm-project/raw/main/llvm/utils/vim/indent/$vimscript )
done

wait
