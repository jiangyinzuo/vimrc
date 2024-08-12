function fzf_custom#fzf#mergetool_start(f)
	execute 'tabnew ' . a:f
	:MergetoolStart
	tabclose -1
endfunction

function fzf_custom#fzf#backup(f)
	let current_ft = &ft
	exe 'vsp ' . a:f
	exe 'set ft=' . current_ft
endfunction
