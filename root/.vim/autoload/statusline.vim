let s:cached_branch = ''
let s:last_update_time = 0

function! s:GetGitBranchCB(channel, message)
	let s:cached_branch = a:message
	let s:last_update_time = localtime()
endfunction

function s:GetGitBranch()
	let l:current_time = localtime()
	if l:current_time - s:last_update_time < 5
		return s:cached_branch
	endif

	let l:cmd = ['git', 'rev-parse', '--abbrev-ref', 'HEAD']
	call job_start(l:cmd, {'out_cb': 's:GetGitBranchCB'})
	return s:cached_branch
endfunction

function statusline#LeftStatusLine()
	let l:result = ''
	if &diff == 0 && winwidth(0) > 60
		let l:gitbranch = s:GetGitBranch()
		let l:result .= l:gitbranch == '' ? '' : (' ' . l:gitbranch . ' ')

		if g:vimrc_use_coc
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
	if &diff == 0 && winwidth(0) > 60
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

