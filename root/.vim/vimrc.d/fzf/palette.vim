function s:exec_command_palette(line)
	let l:cmd = filter(split(a:line, '\t'), 'v:val != ""')
	" 把l:cmd放到Command Line且不执行
	call feedkeys(l:cmd[1])
endfunction

function Palette()
	call fzf#run(fzf#wrap({'source': "$VIMRC_ROOT/palette.sh", 'sink': function("s:exec_command_palette")}))
endfunction

" palette在vimscript注释中的格式如下，记得用tab键分隔
" [[palette]]命令面板						:Palette
command! -nargs=0 Palette call Palette()

