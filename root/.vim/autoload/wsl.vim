vim9script
export def Open(filename: string)
	if filereadable(filename) && has('unix') && exists('$WSLENV')
		asyncrun#run('', {'silent': 1}, 'x-www-browser `wslpath -w ' .. filename .. '`')
	else
		echoerr 'File not found: ' .. filename
	endif
enddef
