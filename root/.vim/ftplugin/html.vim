if exists('$WSLENV')
	command! -buffer -nargs=0 BrowserPreview call wsl#BrowserPreview()
endif
