function! mycpp#FoldExpr(lnum)
	let line = getline(a:lnum)
	if !exists('b:cpp_fold_level')
		let b:cpp_fold_level = 0
		let b:last_primitive = ''
	endif

	let open_braces = len(split(line, '{', 1)) - 1
	let close_braces = len(split(line, '}', 1)) - 1
	
	if b:last_primitive == 'if'
		let b:cpp_fold_level += 1
	elseif b:last_primitive == 'end'
		let b:cpp_fold_level -= 1
	endif
	let b:last_primitive = ''
	
	if line =~ '^\s*#\s*\(ifdef\|ifndef\|if\)' || open_braces > close_braces
		let b:cpp_fold_level += 1
		let b:last_primitive = 'if'
		return b:cpp_fold_level
	elseif line =~ '^\s*#\s*\(else\|elif\)' || (open_braces == close_braces && open_braces > 0)
		return b:cpp_fold_level - 1
	elseif line =~ '^\s*#\s*endif' || close_braces > open_braces
		let b:last_primitive = 'end'
		let b:cpp_fold_level -= 1
		return b:cpp_fold_level
	endif

	return b:cpp_fold_level
endfunction

" VIM学习笔记 自动补全详解(Auto-Completion Detail) - YYQ的文章 - 知乎
" https://zhuanlan.zhihu.com/p/106309525
function! mycpp#CompleteFunc(findstart, base)
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
		else
			let completions = []
		endif
		" 使用getcompletion()获取文件类型的补全列表
		echom a:base
		let completions += getcompletion(a:base . '*.h*', 'file_in_path', 1)
		let completions += getcompletion(a:base . '*/$', 'file_in_path', 1)
		return completions
	endif
	return []
endfunction
