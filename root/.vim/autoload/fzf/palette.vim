function s:exec_command_palette(line)
	let l:cmd = filter(split(a:line, '\t'), 'v:val != ""')
	" 把l:cmd放到Command Line且不执行
	call feedkeys(l:cmd[1])
endfunction

function fzf#palette#Palette()
	call fzf#run(fzf#wrap({'source': "$VIMRC_ROOT/palette.sh", 'sink': function("s:exec_command_palette")}))
endfunction

