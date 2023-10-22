function duckdb#DuckDBExec(cmd)
	let cmd = g:duckdb_exe . ' -c "' . a:cmd . '"'
	call asyncrun#run('!', {'save': 1, 'silent': 1, 'raw': 1, 'mode': 'terminal'}, cmd)
endfunction

