" The popup window always has focus, it is not possible to switch to another window.
" See *popup-terminal*

let g:floaterm_opener = 'vsplit'
let g:floaterm_width = 0.95
let g:floaterm_height = 0.95
let g:floaterm_position = 'right'
let g:floaterm_rootmarkers = g:RootMarks
" imap中F12被映射为UltiSnipsExpandTrigger, see plugin.vim
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_title='<F8> kill | <F9> new | <F10> prev | <F11> next | <F12> toggle ($1/$2)'
" 在floaterm中才会生效的快捷键
augroup FloatermShortcuts
  autocmd!
  autocmd FileType floaterm tnoremap <buffer> <F8>  <C-\><C-n>:FloatermKill<CR>
  autocmd FileType floaterm tnoremap <buffer> <F9>  <C-\><C-n>:FloatermNew<CR>
  autocmd FileType floaterm tnoremap <buffer> <F10> <C-\><C-n>:FloatermPrev<CR>
  autocmd FileType floaterm tnoremap <buffer> <F11> <C-\><C-n>:FloatermNext<CR>
augroup END

command Vifm :FloatermNew --opener=e vifm
command! NNN FloatermNew nnn
