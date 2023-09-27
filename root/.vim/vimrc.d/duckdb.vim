let g:duckdb_exe = 'duckdb -markdown'
function DuckDBExec(cmd)
	let cmd = g:duckdb_exe . ' -c "' . a:cmd . '"'
	call asyncrun#run('!', {'save': 1, 'silent': 1, 'raw': 1, 'mode': 'terminal'}, cmd)
endfunction

" [[palette]]DuckDB执行SQL,输出到terminal				:DuckDBExec select 42
command -nargs=1 DuckDBExec call DuckDBExec(<q-args>)
" [[palette]]DuckDB执行文件里的SQL,输出到terminal			:DuckDBExec foo.sql
command -nargs=1 -complete=file DuckDBExecFile call DuckDBExec('.read ' . <q-args>)
