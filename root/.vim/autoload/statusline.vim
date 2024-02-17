function statusline#LeftStatusLine()
	let l:result = ''
	if &diff == 0 && winwidth(0) > 60
		if exists('*FugitiveHead')
			let l:gitbranch = FugitiveHead()
			let l:result .= l:gitbranch == '' ? '' : (' ' . l:gitbranch . ' ')
		endif
		if exists('*coc#status')
			let l:coc_current_function = get(b:, 'coc_current_function', '')
			let l:result .= l:coc_current_function == '' ? '' : (' ' . l:coc_current_function . ' ')
			let l:cocstat = coc#status()
			let l:result .= l:cocstat == '' ? '' : (l:cocstat . ' ')
		endif
	endif
	return l:result
endfunction

function statusline#RightStatusLine()
	let l:result = ''
	if &diff == 0 && winwidth(0) > 60 && exists('g:asyncrun_status')
		if g:asyncrun_status == 'running'
			let l:result .= ' '
		elseif g:asyncrun_status == 'success'
			let l:result .= '󰄴 '
		elseif g:asyncrun_status == 'failure'
			let l:result .= ' '
		endif
	endif
	return l:result
endfunction

