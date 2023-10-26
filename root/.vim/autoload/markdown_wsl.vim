vim9script
if (has('unix') && exists('$WSLENV'))
	# TODO: get root by ascynrun#get_root
	const basepath = 'D:/doc2'
	const wsl_basepath = $DOC2

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
		if uri =~ '^/mnt/d/'
			uri = substitute(uri, '/mnt/d', 'D:', '')
		elseif uri =~ '^/mnt/c/'
			uri = substitute(uri, '/mnt/c', 'C:', '')
		else
			uri = 'file://wsl.localhost/Ubuntu-22.04' .. uri
		endif
		job_start('x-www-browser "' .. uri .. '"')
	enddef
endif
