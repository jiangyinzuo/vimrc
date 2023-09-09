function markdown#YankWikiLink(line1, line2)
	let s:wiki_link ='[[' . expand("%:t") . ']]'
	let @" = s:wiki_link"
	if a:line1 == a:line2
		let @" .= "\n"
	else
		let @" .= "\n" . join(getline(a:line1, a:line2), "\n")
		let @" .= "\n"
	endif
endfunction

