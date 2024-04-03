function! asynctasks_custom#MakefileComplete(ArgLead, CmdLine, CursorPos)
	" See Also: https://github.com/jiangyinzuo/vimrc/commit/29a7f3f4686c4ea8246c2f149f698fd01d7cdba4#commitcomment-139545459
	" read and parse Makefile
	try
		let l:lines = readfile('Makefile')
	catch /.*/
		return []
	endtry
	let l:targets = []

	for line in l:lines
		if line =~ '^\w.*:'
			let target = matchstr(line, '^\([a-zA-Z/0-9_-]\|\.\)\+')
			" Only add targets that match ArgLead
			if target =~ '^' . a:ArgLead
				call add(l:targets, target)
			endif
		endif
	endfor

	return l:targets->uniq()
endfunction
