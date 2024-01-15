fun NFH_md(filename)
	call wsl#Open(a:filename)
endfun

fun s:XdgOpen(filename)
	let l:prefix = ''
	let l:longest_matched_index = 99999
	let l:current_buffer_filepath = expand('%:t')
	for pair in g:gx_filepath_prefixes
		let l:matched_index = match(l:current_buffer_filepath, glob2regpat(pair[0]))
		echom 'l:matched_index ' .  l:matched_index
		echom 'pair ' . pair[0] . ' ' . pair[1]
		if l:matched_index >= 0 && l:matched_index < l:longest_matched_index
			let l:longest_matched_index = l:matched_index
			let l:prefix = pair[1]
		endif
	endfor
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
