" See: github.com/junegunn/fzf.vim/issues/1037
" HelpRg command -- like helpgrep but with FZF and ripgrep
let s:helppaths = uniq(sort(split(globpath(&runtimepath, 'doc/', 1), '\n')))

function fzf_custom#rg#ListDocs(A, L, P)
	let result = ''
	for helppath in s:helppaths
		let result = result . system("ls " . helppath . " | grep ^" . a:A)
	endfor
	return result
endfunction

function s:help_rg_sink(item)
	let parts = split(a:item, ':')
	let filename = parts[0]
	let lnum = parts[1]
	execute 'edit +' . lnum . ' ' . filename
	set ft=help
	set readonly
	set nomodifiable
	norm! zz
endfunction

function fzf_custom#rg#HelpRg(word, fullscreen)
	if a:word == ""
		call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case -g "*.txt" -g "*.cnx" "" '. join(s:helppaths), 1, fzf#wrap({'sink': function('s:help_rg_sink')}), a:fullscreen)
	else
		call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case -g "*.txt" -g "*.cnx" "' . a:word . '" '. join(s:helppaths), 1, fzf#wrap({'sink': function('s:help_rg_sink')}), a:fullscreen)
	end
	set readonly
	set ft=help
endfunction
