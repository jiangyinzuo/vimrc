fun NFH_md(filename)
	call wsl#Open(a:filename)
endfun

fun NFH_eps(filename)
	call asyncrun#run('', {'silent': 1}, 'xdg-open ' . a:filename)
endfun

fun NFH_pdf(filename)
	call asyncrun#run('', {'silent': 1}, 'xdg-open ' . a:filename)
endfun

fun NFH_jpg(filename)
	call asyncrun#run('', {'silent': 1}, 'xdg-open ' . a:filename)
endfun

fun NFH_png(filename)
	call asyncrun#run('', {'silent': 1}, 'xdg-open ' . a:filename)
endfun
