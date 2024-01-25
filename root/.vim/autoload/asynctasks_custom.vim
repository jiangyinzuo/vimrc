function! asynctasks_custom#MakefileComplete(ArgLead, CmdLine, CursorPos)
	" 读取和解析 Makefile
	let l:lines = readfile('Makefile')
	let l:targets = []

	for line in l:lines
		if line =~ '^\w.*:'
			let target = matchstr(line, '^\w\+')
			" 只添加与 ArgLead 匹配的目标
			if target =~ '^' . a:ArgLead
				call add(l:targets, target)
			endif
		endif
	endfor

	return l:targets->uniq()
endfunction
