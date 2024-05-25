if g:vimrc_lsp == 'coc.nvim'
	" See: https://github.com/dansomething/coc-java-debug
	function! JavaStartDebugCallback(err, port)
		execute "cexpr! 'Java debug started on port: " . a:port . "'"
		call vimspector#LaunchWithSettings({ "configuration": "Java Attach", "AdapterPort": a:port })
	endfunction

	function JavaRunDebugMode()
		let l:class_name = expand('%:t:r')
		execute 'AsyncRun -pos=tab -mode=term -name=' . l:class_name . ' -cwd=' . getcwd() . ' javac -g ' . l:class_name .'.java && java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y ' . l:class_name
		tabp
	endfunction

	function JavaStartDebug()
		call CocActionAsync('runCommand', 'vscode.java.startDebugSession', function('JavaStartDebugCallback'))
	endfunction

	" 调试Java单文件时，先运行JavaRunDebugMode，再运行JavaStartDebug
	command -nargs=0 JavaRunDebugMode call JavaRunDebugMode()
	command -nargs=0 JavaStartDebug call JavaStartDebug()
endif
