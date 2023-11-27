command! -range -nargs=0 YankWikiLink call markdown#YankWikiLink(<line1>, <line2>)

" ASCII of ~ is 126
" See: :h surround-customizing
let b:surround_126 = "~~\r~~"
