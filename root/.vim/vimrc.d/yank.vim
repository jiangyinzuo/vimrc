" 复制pathline用于gF文件跳转
" See rffv() in fzf/fzf.bash
command! -nargs=0 YankPathLine let @" = expand('%:p')[len(asyncrun#get_root('%')) + 1:] . ':' . line(".")

function s:yank_gdb() range
	" 复制选中的内容到临时变量
	let temp_text = getline(a:firstline, a:lastline)
	" 通过正则表达式匹配 /path/to/file.ext:linenumber 格式的行
	let result_lines = filter(temp_text, 'v:val =~# "[A-Za-z0-9\\-./]\\+:[0-9]\\+"')
	" 将结果复制到匿名寄存器中
	let @" = join(result_lines, "\n")
endfunction

command! -range -nargs=0 YankGDB <line1>,<line2>call s:yank_gdb()

