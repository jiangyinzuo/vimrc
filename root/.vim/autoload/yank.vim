function yank#YankPathLine()
	let current_root = asyncrun#current_root()
	let @" = expand('%:p')[len(current_root) + 1:] . ':' . line(".")
endfunction

function yank#YankPathLineAndContent() range
	let current_root = asyncrun#current_root()
	let @" = expand('%:p')[len(current_root) + 1:] . ':' . a:firstline
	let @" .= "\n" . join(getline(a:firstline, a:lastline), "\n")
endfunction

