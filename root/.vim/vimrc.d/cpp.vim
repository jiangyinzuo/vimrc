Plug 'bfrg/vim-cpp-modern', {'for': 'cpp'}
" Enable function highlighting (affects both C and C++ files)
let g:cpp_function_highlight = 1

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

" 当前cursor位于cpp头文件方法上，复制cpp头文件中方法定义，自动添加类名
function CppImpl()
	let l:current_line_number = line('.')

	" 向上找到类名
	let l:class_line_number = l:current_line_number
	let className = ''
	while l:class_line_number > 0 && className == ''
		let className = matchstr(getline(l:class_line_number), 'class \zs\w\+')
		let l:class_line_number = l:class_line_number - 1
	endwhile

	let l:current_line = getline(l:current_line_number)
	" 去掉末尾)和;之间的内容
	let l:current_line = substitute(l:current_line, ').*;.*$', ');', '')
	" 去掉开头的virtual关键字
	let l:current_line = substitute(l:current_line, '^\s*virtual\s*', '', '')
	" 将l:current_line中的;替换为{}
	let l:current_line = substitute(l:current_line, ';', ' {\n}', '')
	" 在l:current_line中方法名前面添加 className::
	let l:current_line = substitute(l:current_line, '\(\w\+\)(\(.*\))', className .'::\1(\2)', '')
	" 复制到默认寄存器
	let @" = l:current_line
endfunction
command CppImpl call CppImpl()
