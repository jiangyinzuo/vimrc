let g:duckdb_exe = get(g:, 'duckdb_exe', 'duckdb -markdown')
" [[palette]]DuckDB执行SQL,输出到terminal				:DuckDBExec select 42
command -nargs=? -range DuckDBExec call duckdb#DuckDBExec(<q-args>, <line1>, <line2>)
" [[palette]]DuckDB执行文件里的SQL,输出到terminal			:DuckDBExec foo.sql
command -nargs=1 -complete=file DuckDBExecFile call duckdb#DuckDBExec('.read ' . <q-args>)
