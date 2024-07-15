setlocal commentstring=//\ %s
" setlocal equalprg=indent
" setlocal equalprg=uncrustify\ -c\ .uncrustify.cfg\ --replace\ --no-backup
if expand('%:p') =~ '^/usr/include/\(\(c++\)\|\(\w\+\.h$\)\)'
	setlocal tabstop=8 shiftwidth=8 softtabstop=8
else
	setlocal tabstop=2 shiftwidth=2 softtabstop=2
endif

if !has('nvim')
	" 搜索的模式是一个正则表达式，用来匹配不是在if, for, while, switch, 和catch后面的左花括号{，因为在C++中函数的定义是以左花括号开始的。
	" 需要注意的是，这个搜索模式可能并不完全精确，因为函数的定义还可能包含许多其他的复杂性，比如模板函数，函数指针，宏定义等等。对于一些简单的代码文件，这个方法通常可以工作得很好。
	" 这些配置会更好地在代码中快速导航，但如果你需要更精确地识别函数，你可能需要考虑使用一些更高级的插件，比如ctags,cscope等等。

	" jump to the previous function
	" 向后（b表示backward）搜索一个匹配特定模式的地方，这个模式是一个函数的开始位置。
	nnoremap <silent> <buffer> [f :call search('\(\(if\\|for\\|while\\|switch\\|catch\)\_s*\)\@64<!(\_[^)]*)\_[^;{}()]*\zs{', "bw")<CR>
	" jump to the next function
	" 向前（w表示forward）搜索一个匹配特定模式的地方，这个模式是一个函数的开始位置。
	nnoremap <silent> <buffer> ]f :call search('\(\(if\\|for\\|while\\|switch\\|catch\)\_s*\)\@64<!(\_[^)]*)\_[^;{}()]*\zs{', "w")<CR>

	nnoremap <silent> <buffer> [[ :call search('\<class\>\|\<struct\>\|\<enum\>\|\<typedef\>', "bW")<CR>
	nnoremap <silent> <buffer> ]] :call search('\<class\>\|\<struct\>\|\<enum\>\|\<typedef\>', "wW")<CR>

	setlocal foldmethod=expr foldexpr=mycpp#FoldExpr(v:lnum)
endif

setlocal completefunc=mycpp#CompleteFunc
