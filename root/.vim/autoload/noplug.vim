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
	call s:ShowQuickfixListIfNotEmpty()
endfunction
	
function noplug#MyCppCompleteFunc(findstart, base)
	if a:findstart
		" 确定补全开始的位置
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && line[start - 1] =~ '\S'
			let start -= 1
		endwhile
		if line[start] != '<' && line[start] != '"'
			return -3
		endif
		return start + 1
	endif

	if getline('.') =~# &include
		let filetype = &filetype
		if filetype == 'cpp' || filetype == 'cuda'
			" r! ls -1 /usr/include/c++/13 | awk '{print " \x27"$0"\x27"}' | paste -sd,
			let completions = ['algorithm', 'any', 'array', 'atomic', 'backward', 'barrier', 'bit', 'bits', 'bitset', 'cassert', 'ccomplex', 'cctype', 'cerrno', 'cfenv', 'cfloat', 'charconv', 'chrono', 'cinttypes', 'ciso646', 'climits', 'clocale', 'cmath', 'codecvt', 'compare', 'complex', 'complex.h', 'concepts', 'condition_variable', 'coroutine', 'csetjmp', 'csignal', 'cstdalign', 'cstdarg', 'cstdbool', 'cstddef', 'cstdint', 'cstdio', 'cstdlib', 'cstring', 'ctgmath', 'ctime', 'cuchar', 'cwchar', 'cwctype', 'cxxabi.h', 'debug', 'decimal', 'deque', 'exception', 'execution', 'expected', 'experimental', 'ext', 'fenv.h', 'filesystem', 'format', 'forward_list', 'fstream', 'functional', 'future', 'initializer_list', 'iomanip', 'ios', 'iosfwd', 'iostream', 'istream', 'iterator', 'latch', 'limits', 'list', 'locale', 'map', 'math.h', 'memory', 'memory_resource', 'mutex', 'new', 'numbers', 'numeric', 'optional', 'ostream', 'parallel', 'pstl', 'queue', 'random', 'ranges', 'ratio', 'regex', 'scoped_allocator', 'semaphore', 'set', 'shared_mutex', 'source_location', 'span', 'spanstream', 'sstream', 'stack', 'stacktrace', 'stdatomic.h', 'stdexcept', 'stdfloat', 'stdlib.h', 'stop_token', 'streambuf', 'string', 'string_view', 'syncstream', 'system_error', 'tgmath.h', 'thread', 'tr1', 'tr2', 'tuple', 'typeindex', 'typeinfo', 'type_traits', 'unordered_map', 'unordered_set', 'utility', 'valarray', 'variant', 'vector', 'version']
			call filter(completions, 'v:val =~ "^" . a:base')
		endif
		" 使用getcompletion()获取文件类型的补全列表
		echom a:base
		let completions += getcompletion(a:base . '*.h*', 'file_in_path', 1)
		let completions += getcompletion(a:base . '*/$', 'file_in_path', 1)
		return completions
	endif
	return []
endfunction
