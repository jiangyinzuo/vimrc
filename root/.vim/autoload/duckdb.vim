function! duckdb#DuckDBExec(...)
	if empty(a:000[0])
		" 没有指定SQL语句，尝试从选定范围读取
		let l:sql = join(getline(a:000[1], a:000[2]), ' ')
		if l:sql == ''
			echo "No SQL statement provided."
			return
		endif
	else
		" SQL语句作为参数提供
		let l:sql = a:000[0]
	endif
	let cmd = g:duckdb_exe . ' -c "' . l:sql . '"'
	call asyncrun#run('!', {'save': 1, 'silent': 1, 'raw': 1, 'mode': 'terminal'}, cmd)
endfunction

