" 复制pathline用于gF文件跳转
" See rffv() in fzf/fzf.bash
" [[palette]]复制当前文件:行的pathline				:YankPathLine
command! -nargs=0 YankPathLine let @" = expand('%:p')[len(asyncrun#current_root()) + 1:] . ':' . line(".")

function s:yank_gdb() range
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

command! -range -nargs=0 YankGDB <line1>,<line2>call s:yank_gdb()

if exists("$WSLENV")
	" https://github.com/alacritty/alacritty/issues/2324#issuecomment-1339594232
	inoremap <C-v> <ESC>:silent r!pbpaste<CR>'.kJ
endif
