if exists("b:current_syntax")
  finish
endif
if !exists('b:toggleterm_custom_syntax')
  finish
endif

exe 'runtime! syntax/' . b:toggleterm_custom_syntax . '.vim'
let b:current_syntax = "toggleterm"
