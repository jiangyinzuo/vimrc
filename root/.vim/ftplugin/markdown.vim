command! -range -nargs=0 YankWikiLink call markdown#YankWikiLink(<line1>, <line2>)

setlocal conceallevel=0

" ASCII of ~ is 126
" See: :h surround-customizing
let b:surround_126 = "~~\r~~"
if !has('nvim')
	let g:markdown_folding = 1
endif

if (has('unix') && exists('$WSLENV') && !has('nvim'))
	command! -buffer -nargs=0 MdPreview call wsl#MdPreview()
endif
