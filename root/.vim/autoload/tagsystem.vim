function tagsystem#GtagsCscopeAdd()
	let l:project_root = asyncrun#current_root()
	if l:project_root != $HOME && l:project_root != ''
		let l:gtags_db = l:project_root . '/GTAGS'
		if filereadable(l:gtags_db) && cscope_connection(2, l:gtags_db) == 0
			execute 'cs add ' . l:gtags_db
		endif
	endif
endfunction
