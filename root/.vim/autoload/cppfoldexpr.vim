function! cppfoldexpr#CppFoldExpr(lnum)
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
