fun coc_custom#NetrwGxHandler()
	let result = CocAction('runCommand', 'explorer.getNodeInfo', 0)['fullpath']
	echo result
	call wsl#WSLOpen(result)
endfun
