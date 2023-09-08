function s:yank_def(lineNumber, className)
	let l:current_line = getline(a:lineNumber)
	" 去掉末尾)和;之间的内容
	let l:current_line = substitute(l:current_line, ').*;.*$', ');', '')
	" 去掉开头的virtual关键字
	let l:current_line = substitute(l:current_line, '^\s*virtual\s*', '', '')
	" 将l:current_line中的;替换为{}
	let l:current_line = substitute(l:current_line, ';', ' {\n}', '')
	" 在l:current_line中方法名前面添加 className::
	let l:current_line = substitute(l:current_line, '\(\w\+\)(\(.*\))', a:className .'::\1(\2)', '')
	" 复制到默认寄存器
	let @" = l:current_line
endfunction

" [[palette]]生成cpp类方法的函数定义，放在默认寄存器			:YDef
function YDef(...)
	let l:current_line_number = line('.')

	if a:0 == 0
		let className = ''
		" 向上找到类名
		let l:class_line_number = l:current_line_number
		while l:class_line_number > 0 && className == ''
			let className = matchstr(getline(l:class_line_number), 'class \zs\w\+')
			let l:class_line_number = l:class_line_number - 1
		endwhile
	else
		let className = a:1
	endif
	call s:yank_def(l:current_line_number, className)
endfunction
command -nargs=? YDef call YDef(<f-args>)
