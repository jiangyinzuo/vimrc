fun NFH_md(filename)
	call wsl#Open(a:filename)
endfun

fun s:XdgOpen(filename)
	let l:prefix = g:gx_filepath_prefix->get(&filetype, g:gx_filepath_prefix['default'])
	if (l:prefix =~# '^mycmd://.*') && exists('$WSLENV')
		let l:command = '/mnt/d/url_scheme.exe'
	else
		let l:command = 'xdg-open'
	endif
	echom l:command . ' ' . l:prefix . a:filename
	call asyncrun#run('', {'silent': 1}, l:command . ' ' . l:prefix . a:filename)
endfun

fun NFH_eps(filename)
	call s:XdgOpen(a:filename)
endfun

fun NFH_pdf(filename)
	call s:XdgOpen(a:filename)
endfun

fun NFH_jpg(filename)
	call s:XdgOpen(a:filename)
endfun

fun NFH_png(filename)
	call s:XdgOpen(a:filename)
endfun

fun NFH_gif(filename)
	call s:XdgOpen(a:filename)
endfun

fun NFH_pptx(filename)
	call s:XdgOpen(a:filename)
endfun
