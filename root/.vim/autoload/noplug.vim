function! noplug#MyRead(file)
	" 获取文件大小
	let l:size = getfsize(a:file)
	" 将文件大小转换为MB
	let l:sizeMB = l:size / 1024.0 / 1024.0

	" 检查文件大小是否超过20MB
	if l:sizeMB > 20
		echo "File size exceeds 20MB. Operation cancelled."
	else
		" 调用原生的:read命令读取文件
		execute 'read ' . a:file
	endif
endfunction
function noplug#ToggleQuickfix(list)
	if empty(filter(range(1, winnr('$')), 'getwinvar(v:val, "&buftype") == "quickfix"'))
		let height = len(getqflist())
		let height = height > 7 ? 7 : height
		let height = height < 2 ? 2 : height
		if a:list == 'c'
			exe 'copen ' . height
		else
			exe 'lopen ' . height
		endif
	else
		if a:list == 'c'
			cclose
		else
			lclose
		endif
	endif
endfunction
function s:ShowQuickfixListIfNotEmpty()
	let length = len(getqflist())
	if length > 1
		let height = length > 7 ? 7 : length
		exe 'copen ' . height
	elseif length == 1
		copen
		ccl
	elseif length == 0
		echo 'empty quickfix list'
	endif
endfunction

function noplug#FindWord(word)
	if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'cuda'
		let l:extension = '**/*.c* **/*.h*'
	else
		let l:extension = '**/*.' . expand('%:e')
	endif
	" <pattern>: 匹配整个单词
	exe 'vimgrep /\<'.a:word.'\>/ ' . l:extension
	call s:ShowQuickfixListIfNotEmpty()
endfunction

function noplug#FindType(word)
	" <pattern>: 匹配整个单词
	if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'cuda'
		exe 'vimgrep' '/\<\(struct\|union\|class\) '.a:word.'\>/' '**/*.c*' '**/*.h*'
	elseif &filetype == 'python'
		exe 'vimgrep' '/\<class '.a:word.'\>/' '**/*.py'
	elseif &filetype == 'go'
		exe 'vimgrep' '/\<type '.a:word.'\>/' '**/*.go'
	else
		echo 'unsupport filetype: '.&filetype
		return
	endif
	call s:ShowQuickfixListIfNotEmpty()
endfunction

function noplug#FindDefinitionFunction(word)
	if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'cuda'
		exe 'vimgrep' '/\<'.a:word.'\s*(/ **/*.c* **/*.h*'
	elseif &filetype == 'python'
		exe 'vimgrep' '/\<def '.a:word.'(/' '**/*.py'
	elseif &filetype == 'go'
		exe 'vimgrep' '/\<func '.a:word.'(/' '**/*.go'
	else
		echo 'unsupport filetype: '.&filetype
		return
	endif
	call s:ShowQuickfixListIfNotEmpty()
endfunction

function noplug#SystemToQf(args)
	cexpr system(a:args)
	call setqflist([], 'r', {'title': a:args})
	call s:ShowQuickfixListIfNotEmpty()
endfunction
