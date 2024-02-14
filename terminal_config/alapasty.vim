" Paste text from alacritty (windows) into vim without additional blanklines
" Issue: https://github.com/alacritty/alacritty/issues/2324
" 
" Place this vim file in a plugin directory of vim. Example: $HOME/.vim/plugin/alapasty.vim
" Type `:Ap<Cr>` to open up a buffer in insert mode. Use `Shift+Insert` to copy text into this buffer. 
" Press <Esc> and the text will be formatted and placed in the originating buffer
"
" Note: This plugin takes care of some common edge-cases when working with code. Make sure the first few lines are
" either blank (just line endings is okay) or it has the first line of the content you want to paste. 
" This is critical because the script uses "%normal jdd" to dispatch repetitive jump and delete motions over the entire file.
"
" Author: Sai Sasidhar Maddali <github.com/saisasidhar>
" 
if exists('alapasty') || &cp
  finish
endif
let alapasty=1

let AlapastyBufferName = ".alapasty"

function! s:AlapastyCreate()
  let bufn = bufnr(g:AlapastyBufferName)
  if bufn == -1
    exe "new " . g:AlapastyBufferName
  else
    exe "split +buffer" . bufn
  endif
  exe ":%d"
  set paste
  exe "startinsert"
endfunction

function! s:AlapastyManipulate()
  " count empty lines in the beginning of the buffer
  let ls = line('$')
  let ix = 1
  while ls >= ix
    let line = getbufline('$', ix)
    if len(line[0]) != 0
      break
    endif
    let ix += 1
  endwhile

  " remove empty lines
  normal! gg
  while ix > 1
    exe ":0d"
    let ix -= 1
  endwhile

  " skip formatting and pasting if it does not make any sense (default line feed for an empty buffer)
  if line('$') == 1
    let line = getbufline('$', ix)
    if len(line[0]) == 0
      exe "hide"
      return
    endif
  endif

  " jump every other line and delete it
  exe "%normal jdd"
  normal! Gygg
  exe "hide"
  normal! p
endfunction

function! s:AlapastySetProps()
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal buflisted
endfunction

autocmd BufNewFile .alapasty call s:AlapastySetProps()
autocmd InsertLeave .alapasty call s:AlapastyManipulate()
command! Ap call s:AlapastyCreate()
