function mergetool_custom#MergetoolLayoutCallback(split)
	if exists('*CocActionAsync')
		call CocActionAsync('diagnosticToggleBuffer')
	endif
	setlocal syntax=off
	" disabling gitgutter may not work, so use setlocal signcolumn=no
	" call gitgutter#buffer_disable()
	setlocal signcolumn=no
endfunction

function mergetool_custom#Restore()
	syntax on
	if has("nvim-0.5.0") || has("patch-8.1.1564")
		set signcolumn=number " 合并git状态与行号
	elseif v:version >= 801
		set signcolumn=yes " 同时显示git状态和行号
	endif
endfunction

command -nargs=0 MergetoolRestore call mergetool_custom#Restore()
