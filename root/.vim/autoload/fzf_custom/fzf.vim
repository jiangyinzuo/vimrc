function fzf_custom#fzf#mergetool_start(f)
	execute 'tabnew ' . a:f
	:MergetoolStart
	tabclose -1
endfunction

