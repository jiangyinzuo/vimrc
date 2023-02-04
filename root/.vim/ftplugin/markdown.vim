if (has('unix') && exists('$WSLENV'))
	" 离开插入模式后切换成英语（美国）， 进入插入模式后切换成中文
	augroup smartim
		autocmd!
		" autocmd VimLeavePre * !/mnt/d/im-select.exe 1033
		autocmd InsertLeave * !/mnt/d/im-select.exe 1033
		autocmd InsertEnter * !/mnt/d/im-select.exe 2052
	augroup end
endif
