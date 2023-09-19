let g:duckdb_exe = 'duckdb'
function DuckDBExec(cmd)
	let current_file = expand('%')
	let cmd = g:duckdb_exe . ' -c ".output ' . current_file . '" -c "' . a:cmd . '"'
	call asyncrun#run('!', {'silent': 1}, cmd)
endfunction

command -nargs=1 DuckDBExec call DuckDBExec(<q-args>)
command -nargs=1 -complete=file DuckDBExecFile call DuckDBExec('.read ' . <q-args>)
