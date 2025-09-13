function! asynctasks_custom#MakefileComplete(ArgLead, CmdLine, CursorPos)
	" See Also: https://github.com/jiangyinzuo/vimrc/commit/29a7f3f4686c4ea8246c2f149f698fd01d7cdba4#commitcomment-139545459
	" read and parse Makefile
	try
		let l:lines = readfile('Makefile')
	catch /.*/
		return []
	endtry
	let l:targets = []

	for line in l:lines
		if line =~ '^\w.*:'
			let target = matchstr(line, '^\([a-zA-Z/0-9_-]\|\.\)\+')
			" Only add targets that match ArgLead
			if target =~ '^' . a:ArgLead
				call add(l:targets, target)
			endif
		endif
	endfor

	return l:targets->uniq()
endfunction

function asynctasks_custom#Open(prefix)
	let l:cfile = expand("<cfile>")
	let l:prefix = a:prefix
	if empty(l:prefix) && exists('g:default_open_prefixes')
		let l:longest_matched_index = 99999
		let l:current_buffer_filepath = expand('%:t')
		for pair in g:default_open_prefixes
			let l:matched_index = match(l:current_buffer_filepath, glob2regpat(pair[0]))
			if l:matched_index >= 0 && l:matched_index < l:longest_matched_index
				let l:longest_matched_index = l:matched_index
				let l:prefix = pair[1]
			endif
		endfor
	endif
	let l:filename = l:prefix . l:cfile
	if (l:filename =~# '^mycmd://.*') && exists('$WSLENV')
		let l:command = '/mnt/d/url_scheme.exe'
	else
		let l:command = 'xdg-open'
	endif
	call asyncrun#run('', {'silent': 1}, l:command . ' ' . l:filename)
endfunction

function asynctasks_custom#RunSelected(cmd)
	" 获取选定的文本
	let selected_text = noplug#GetVisualSelection()

	" 构建并执行命令。'a:cmd' 接收用户输入的命令。
	" 注意：如果你的命令不是 'foo -c'，请在此处修改。
	" shellescape() 函数用于安全地转义文本，防止命令注入。
	let full_cmd = a:cmd . ' ' . shellescape(selected_text)

	call asyncrun#run('!', {'save': 1, 'silent': 1, 'raw': 1, 'mode': 'terminal'}, full_cmd)
endfunction
