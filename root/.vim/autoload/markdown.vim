function markdown#YankWikiLink(line1, line2)
	let s:wiki_link ='[[' . expand("%") . ']]'
	let @" = s:wiki_link"
	if a:line1 == a:line2
		let @" .= "\n"
	else
		let @" .= "\n" . join(getline(a:line1, a:line2), "\n")
		let @" .= "\n"
	endif
endfunction

function! markdown#NumberHeadings()
	let l:heading_start_level = 2 " 从2级标题开始编号
	let last_level = 0
	let l:empty = [0, 0, 0, 0, 0, 0]
	let l:count = [0, 0, 0, 0, 0, 0]
	execute "normal! gg"
	let l:last_line = line("$")
	for i in range(1, l:last_line)
		let line_text = getline(".")
		let line_level = len(matchstr(line_text, '^#\+\s')) - l:heading_start_level
		if line_level > 0
			if line_level == 1
				let l:count = [l:count[0] + 1] + l:empty[1 : 5]
			else
				let l:count = l:count[0 : line_level - 2] + [l:count[line_level - 1] + 1] + l:empty[line_level + 1 : 5]
			endif
			" Two Styles:
			"
			" 1.
			" 1.1.
			" 1.1.1.
" 			let number_text = join(l:count[0 : line_level - 1], '.') . '.'
" 			let line_text = substitute(line_text, '^\(\s*#\+\s*\)\(\(\d\+\.\)*\d\+\. \)\?', '\1', '')
			" 1
			" 1.1
			" 1.1.1
			let number_text = join(l:count[0 : line_level - 1], '.')
			let line_text = substitute(line_text, '^\(\s*#\+\s*\)\(\d\+\.\)*\d\+\s\+', '\1', '')

			call setline('.', matchstr(line_text, '^\s*#\+') . ' ' . number_text . matchstr(line_text, '^\s*#\+\zs.*'))
		endif
		execute "normal! j"
	endfor
endfunction

function! markdown#RemoveNumberHeadings()
	execute "normal! gg"
	let l:last_line = line("$")
	for i in range(1, l:last_line)
		let line_text = getline(".")
		" Two Styles:
		"
		" 1.
		" 1.1.
		" 1.1.1.
		" let line_text = substitute(line_text, '^\(\s*#\+\s*\)\(\d\+\.\)*\d\+\. ', '\1', '')
		" 1
		" 1.1
		" 1.1.1
		let line_text = substitute(line_text, '^\(\s*#\+\s*\)\(\d\+\.\)*\d\+ ', '\1', '')
		call setline('.', line_text)
		execute "normal! j"
	endfor
endfunction

