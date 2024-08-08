function ConvertWSLPath(uri)
	" alternative: wslpath -w <uri>
	if a:uri =~ '^/mnt/d/'
		return substitute(a:uri, '/mnt/d', 'D:', '')
	elseif uri =~ '^/mnt/c/'
		return substitute(a:uri, '/mnt/c', 'C:', '')
	else
		return 'file://wsl.localhost/Ubuntu-22.04' . uri
	endif
endfunction

" xdg-open <uri>
" cmd.exe /C start "" 需要使用cmd.exe /c mklink创建软链接
" explorer.exe
"
" do not work.
"
" x-www-browser <uri> need `update-alternatives --config x-www-browser` to setup default programs.
"
" sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser <browser-path> <priority_as_integer>
"
" Example:
" sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser '/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe' 200
" sudo update-alternatives --config x-www-browser
function wsl#BrowserPreview()
	if has('nvim')
		call jobstart('x-www-browser "' . ConvertWSLPath(expand("%:p")) . '"')
	else
		call job_start('x-www-browser "' . ConvertWSLPath(expand("%:p")) . '"')
	endif
endfunction

function WSLOpen(uri)
	let uri_converted = ConvertWSLPath(a:uri)
	if has('nvim')
		if uri_converted =~ '\.md$'
			call jobstart('x-www-browser "' . uri_converted . '"')
		else
			call jobstart('cmd.exe /c start "" ' . uri_converted . '')
		endif
	else
		if uri_converted =~ '\.md$'
			call job_start('x-www-browser "' . uri_converted . '"')
		else
			call job_start('cmd.exe /c start "" ' . uri_converted . '')
		endif
	endif
endfunction
