function yank#YankPathLine()
	let current_root = asyncrun#current_root()
	let @" = expand('%:p')[len(current_root) + 1:] . ':' . line(".")
endfunction

function yank#YankPathLineAndContent() range
	let current_root = asyncrun#current_root()
	let @" = expand('%:p')[len(current_root) + 1:] . ':' . a:firstline
	let @" .= "\n" . join(getline(a:firstline, a:lastline), "\n")
endfunction

function yank#YankGDB() range
	" 复制选中的内容到临时变量
	let temp_text = getline(a:firstline, a:lastline)
	" 通过正则表达式匹配 /path/to/file.ext:linenumber 格式的行
	let result_lines = filter(temp_text, 'v:val =~# "[A-Za-z0-9\\-./]\\+:[0-9]\\+"')
	" 将结果复制到匿名寄存器中
	let l:content = join(result_lines, "\n")
	if exists("g:coderepo_dir")
		let l:pattern = substitute(g:coderepo_dir . '/', "/", "\\\\/", "g")
		let l:content = substitute(l:content, l:pattern, "", "g")
	endif
	let @" = l:content
endfunction

