vim9script

export def Left(): string
	var result = ''
	if !&diff && winwidth(0) > 60
		result = ' | '
		if exists('*g:FugitiveHead')
			const gitbranch = g:FugitiveHead()
			if gitbranch != ''
				result ..= ' ' .. gitbranch .. ' '
			endif
		endif
		if exists('*coc#status')
			# Some functions are too long to put into statusline.
			# Please directly echo b:coc_current_function.
			result ..= coc#status()
		endif
	endif
	return result
enddef

export def Right(): string
	var result = ''
	if !&diff && winwidth(0) > 60 && exists('g:asyncrun_status')
		if g:asyncrun_status == 'running'
			result ..= ' '
		elseif g:asyncrun_status == 'success'
			result ..= '󰄴 '
		elseif g:asyncrun_status == 'failure'
			result ..= ' '
		endif
		result ..= '%l/%L:%v %Y %{&fenc} %{&ff}'
	endif
	return result
enddef
