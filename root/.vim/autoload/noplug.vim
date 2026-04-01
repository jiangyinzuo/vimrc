function noplug#GetVisualSelection()
	" https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	if (line2byte(line_start) + column_start) > (line2byte(line_end) + column_end)
		let [line_start, column_start, line_end, column_end] = [line_end, column_end, line_start, column_start]
	endif
	let lines = getline(line_start, line_end)
	if empty(lines)
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection ==# 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction

function noplug#ToggleQuickfix(list)
	if empty(filter(range(1, winnr('$')), 'getwinvar(v:val, "&buftype") == "quickfix"'))
		if a:list == 'c'
			let height = len(getqflist())
			let height = height > 7 ? 7 : height
			let height = height < 2 ? 2 : height
			exe 'copen ' . height
		else
			let height = len(getloclist(0))
			if height == 0
				echom 'empty loclist'
				return
			endif
			let height = height > 7 ? 7 : height
			let height = height < 2 ? 2 : height
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

function noplug#SystemToQf(args)
	cexpr system(a:args)
	call setqflist([], 'r', {'title': a:args})
	call s:ShowQuickfixListIfNotEmpty()
endfunction

function noplug#AsyncRunOrSystem(cmd)
	if exists("*asyncrun#run")
		call asyncrun#run('', {'mode': 'term', 'pos': 'hide', 'silent': 1}, a:cmd)
	else
		call system(a:cmd)
	endif
endfunction
" NOTE: 运行 clean-vim-backup.py，仅保留最新的1个备份版本
function noplug#BackupFile()
	" 获取当前文件的大小（单位：字节）
	let l:filesize = getfsize(expand('%:p'))
	" 设置大小阈值为5MB
	let l:maxsize = 5 * 1024 * 1024
	if l:filesize > l:maxsize
		return
	endif
	if !exists("b:backup_dir")
		let l:absolute_file_folder = expand("%:p:h")
		" if do not start with / (oil:), ignore it
		if l:absolute_file_folder[0] != '/'
			return
		endif
		let b:backup_dir = expand("~/.vim/backup") . l:absolute_file_folder
		if !isdirectory(b:backup_dir)
			call mkdir(b:backup_dir, "p", 0700)
		endif
	endif
	call noplug#AsyncRunOrSystem('cp ' . expand('%:p') . ' ' . b:backup_dir . '/' . expand('%:t') . strftime("~~%Y-%m%d-%H:%M:%S") . '.bak')
endfunction

function noplug#JoinWrappedLine(first, last, pat) range
	let l:lines = getline(a:first, a:last)
	let l:out = []
	let l:cur = ''

	if a:pat =~# '^/.*/$'
		let l:re = a:pat[1:-2]
	else
		let l:re = '^' . escape(a:pat, '\.^$~[]')
	endif

	for l:line in l:lines
		if l:line =~# l:re
			if !empty(l:cur)
				call add(l:out, l:cur)
			endif
			let l:cur = l:line
		else
			if empty(l:cur)
				let l:cur = l:line
			else
				let l:cur .= substitute(l:line, '^\s*', '', '')
			endif
		endif
	endfor

	if !empty(l:cur)
		call add(l:out, l:cur)
	endif

	call setline(a:first, l:out)

	let l:old_count = a:last - a:first + 1
	let l:new_count = len(l:out)
	if l:new_count < l:old_count
		execute (a:first + l:new_count) . ',' . a:last . 'delete _'
	endif
endfunction
