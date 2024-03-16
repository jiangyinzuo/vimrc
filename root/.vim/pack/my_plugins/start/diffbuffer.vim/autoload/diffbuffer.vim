function! diffbuffer#SaveTempFile()
	" 定义临时文件路径
	let temp_file = tempname()
	" 保存当前缓冲区内容到临时文件
	execute 'write! ' . temp_file
	" 将临时文件路径存储起来，以便后续使用
	let s:temp_file = temp_file
endfunction

function diffbuffer#Diff()
	" 获取临时文件路径
	let temp_file = s:temp_file
	" 执行 diff 命令
	execute 'diffthis'
	execute 'vsplit ' . temp_file
	execute 'diffthis'
endfunction

function diffbuffer#DiffExternal(external_command)
	" 获取临时文件路径
	let temp_file = tempname()
	execute 'write! ' . temp_file
	execute ':FloatermNew ' . a:external_command . ' ' . s:temp_file . ' ' . temp_file
endfunction

function diffbuffer#ExternalToolsComplete(arglead, cmdline, cursorpos)
	return "diff\ndelta\n"
endfunction
