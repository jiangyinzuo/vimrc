if has('python3') && !has('nvim')
	command! -nargs=0 -buffer AICommitMessage call ai#GitCommitMessage(
		\ system('git --no-pager diff ' . (getenv('GIT_REFLOG_ACTION') =~# 'amend' ? 'HEAD^ --cached' : '--staged')))
endif
