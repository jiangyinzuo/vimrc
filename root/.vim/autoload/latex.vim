vim9script

export def OpenPPTX()
	normal! vi{"ay
	const current_word = @a
	const pptx_file = substitute(current_word, 'pdf', 'pptx', '')
	if filereadable(pptx_file)
		call asyncrun#run('', {'silent': 1}, 'xdg-open ' .. pptx_file)
	else
		echoerr 'File not found: ' .. pptx_file
	endif
enddef
