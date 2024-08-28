function latex#OpenPPTX()
	normal! vi{"ay
	let current_word = @a
	let pptx_file = substitute(current_word, 'pdf', 'pptx', '')
	if filereadable(pptx_file)
		call asyncrun#run('', {'silent': 1}, 'xdg-open ' . pptx_file)
	else
		echoerr 'File not found: ' . pptx_file
	endif
endfunction

function latex#SumatraPDFSendToVim(args)
	"24 d:\hello\world.tex -> ['24', 'd', '\hello\world.tex']
	let l:arglist = split(a:args, '[: ]') 

	let l:line = l:arglist[0]
	let l:diskname = l:arglist[1]
	let l:diskname = tolower(l:diskname)

	" \hello\world.tex -> /mnt/d/hello/world.tex
	let l:wslpath = l:arglist[2]
	let l:wslpath = substitute(l:wslpath, '\', "/", "g")

	let l:newargs = join([l:line, ' /mnt/', l:diskname, l:wslpath], '')
	execute 'edit +' . l:newargs
endfunction

function latex#LatexPasteImage(relpath)
	execute "normal! i\\includegraphics{" . a:relpath . "}\r\\caption{I"
	let ipos = getcurpos()
	execute "normal! a" . "mage}"
	call setpos('.', ipos)
	execute "normal! ve\<C-g>"
endfunction
