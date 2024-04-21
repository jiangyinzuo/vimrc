let l = getloclist(0)
if !empty(l)
	nnoremap <buffer> j :call setloclist(0, [], 'r', {'idx': line('.') + 1})<CR>
	nnoremap <buffer> k :call setloclist(0, [], 'r', {'idx': line('.') - 1})<CR>
else
	nnoremap <buffer> j :call setqflist([], 'r', {'idx': line('.') + 1})<CR>
	nnoremap <buffer> k :call setqflist([], 'r', {'idx': line('.') - 1})<CR>
endif
nnoremap <silent><buffer> p <cmd>call quickui#tools#preview_quickfix()<cr>
