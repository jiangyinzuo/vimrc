vim9script
export def Open(filename: string)
	if filereadable(filename) && has('unix') && exists('$WSLENV')
		asyncrun#run('', {'silent': 1}, 'x-www-browser `wslpath -w ' .. filename .. '`')
	else
		echoerr 'File not found: ' .. filename
	endif
enddef

def ConvertWSLPath(uri: string): string
	# alternative: wslpath -w <uri>
	if uri =~ '^/mnt/d/'
		return substitute(uri, '/mnt/d', 'D:', '')
	elseif uri =~ '^/mnt/c/'
		return substitute(uri, '/mnt/c', 'C:', '')
	else
		return 'file://wsl.localhost/Ubuntu-22.04' .. uri
	endif
enddef
# xdg-open <uri>
# cmd.exe /C start "" 需要使用cmd.exe /c mklink创建软链接
# explorer.exe
#
# do not work.
#
# x-www-browser <uri> need `update-alternatives --config x-www-browser` to setup default programs.
# 
# sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser <browser-path> <priority_as_integer>
#
# Example:
# sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser '/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe' 200
# sudo update-alternatives --config x-www-browser
#
export def MdPreview()
	var uri = expand("%:p")
	uri = ConvertWSLPath(uri)
	job_start('x-www-browser "' .. uri .. '"')
enddef

export def WSLOpen(uri: string)
	const uri_converted = ConvertWSLPath(uri)
	if uri_converted =~ '\.md$'
		job_start('x-www-browser "' .. uri_converted .. '"')
	else
		job_start('cmd.exe /c start "" ' .. uri_converted .. '')
	endif
enddef
