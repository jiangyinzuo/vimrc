" https://github.com/timakro/vim-yadi/blob/main/plugin/yadi.vim
function detect_indent#DetectIndent()
	let tabbed = 0
	let spaced = 0
	let indents = {}
	let lastwidth = 0
	" get the last 300 lines
	let l:first_line = max([0, line('$')-300])
	for line in getline(l:first_line, line('$'))
		if line[0] == "\t"
			let tabbed += 1
		else
			" The position of the first non-space character is the
			" indentation width.
			let width = match(line, "[^ ]")
			if width != -1
				if width > 0
					let spaced += 1
				endif
				let indent = width - lastwidth
				if indent >= 2 " Minimum indentation is 2 spaces
					let indents[indent] = get(indents, indent, 0) + 1
				endif
				let lastwidth = width
			endif
		endif
	endfor

	let total = 0
	let max = 0
	let winner = -1
	for [indent, n] in items(indents)
		let total += n
		if n > max
			let max = n
			let winner = indent
		endif
	endfor

	if tabbed > spaced*4 " Over 80% tabs
		" echo "Detected indent: tab"
		setlocal noexpandtab shiftwidth=0 softtabstop=0
	elseif spaced > tabbed*4 && max*5 > total*3
		" Detected over 80% spaces and the most common indentation level makes
		" up over 60% of all indentations in the file.
		" echo "Detected indent: " . winner . " spaces"
		setlocal expandtab
		let &shiftwidth=winner
		let &softtabstop=winner
	endif
endfunction
