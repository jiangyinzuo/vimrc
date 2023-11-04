function! s:SerializeValue(Value)
	if type(a:Value) == type(function('function'))
		return string(a:Value)
	elseif type(a:Value) == type({})
		return '{' . join(map(items(a:Value), {idx, item -> '"' . item[0] . '": ' . s:SerializeValue(item[1])}), ', ') . '}'
	else
		return json_encode(a:Value)
	endif
endfunction

" TODO: 维护一个需要保存的g:variables变量列表
let g:save_variables = ['g:code_link_dict']

function! s:SaveTabVariables(filename)
	let l:currentTab = tabpagenr()
	let l:numTabs = tabpagenr('$')

	for g_var in g:save_variables
		if exists(g_var)
			let Value = eval(g_var)
			let escaped_value = s:SerializeValue(Value)
			let escaped_varname = escape(g_var, ' ')
			echo 'let ' . escaped_varname . ' = ' . escaped_value . ''
		endif
	endfor
	echo 'tabfirst'
	for i in range(1, l:numTabs)
		execute 'tabnext' i
		" Output the current tab variables
		for varname in keys(t:)
			let Value = t:[varname]
			let escaped_value = s:SerializeValue(Value)
			let escaped_varname = escape(varname, ' ')
			echo 'let t:' . escaped_varname . ' = ' . escaped_value . ''
		endfor
		echo 'tabnext'
	endfor

	execute 'tabnext' l:currentTab
endfunction

function! mksession#MkSession(sessionfile)
	" Save the session
	execute 'mksession! ' . a:sessionfile

	" Save the tab variables, appended to the session file
	execute 'redir >> ' . a:sessionfile
	call s:SaveTabVariables(a:sessionfile)
	redir END
endfunction
