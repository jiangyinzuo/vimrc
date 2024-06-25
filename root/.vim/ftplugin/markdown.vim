command -range -nargs=0 -buffer YankWikiLink call markdown#YankWikiLink(<line1>, <line2>)
command -nargs=0 -buffer NumberHeadings call markdown#NumberHeadings()
command -nargs=0 -buffer RemoveNumberHeadings call markdown#RemoveNumberHeadings()

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

