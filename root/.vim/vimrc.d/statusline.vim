let s:cached_branch = ''
let s:last_update_time = 0

function GetGitBranchCB(channel, message)
	let s:cached_branch = a:message
	let s:last_update_time = localtime()
endfunction

function GetGitBranch()
	let l:current_time = localtime()
	if l:current_time - s:last_update_time < 5
		return s:cached_branch
	endif

	let l:cmd = ['git', 'rev-parse', '--abbrev-ref', 'HEAD']
	call job_start(l:cmd, {'out_cb': 'GetGitBranchCB'})
	return s:cached_branch
endfunction

function LeftStatusLine()
	let l:result = ''
	
	let l:gitbranch = GetGitBranch()
	let l:result .= l:gitbranch == '' ? '' : (' ' . l:gitbranch . ' ')
	
	let l:coc_current_function = get(b:, 'coc_current_function', '')
	let l:result .= l:coc_current_function == '' ? '' : ('󰊕 ' . l:coc_current_function . ' ')

	let l:cocstat = coc#status()
	let l:result .= l:cocstat == '' ? '' : (l:cocstat . ' ')

	return l:result
endfunction

function RightStatusLine()
	let l:result = ''
	if g:asyncrun_status == 'running'
		let l:result .= ' '
	elseif g:asyncrun_status == 'success'
		let l:result .= '󰄴 '
	elseif g:asyncrun_status == 'failure'
		let l:result .= ' '
	endif
	return l:result
endfunction
