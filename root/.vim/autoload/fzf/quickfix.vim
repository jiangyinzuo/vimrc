function! s:QuickfixListFormat()
  let qf_list = getqflist()
  let formatted_list = []

	let l:i = 0
  for item in qf_list
    let filename = bufname(item.bufnr)
    let line_number = item.lnum
    let text = item.text

    call add(formatted_list, l:i . '	' . filename . ':' . line_number . '			' . text)
		let l:i = l:i + 1
  endfor

  return formatted_list
endfunction

function! fzf#quickfix#Quickfix()
  call fzf#run(fzf#wrap({
  \ 'source': s:QuickfixListFormat(),
  \ 'sink':   function('s:open_quickfix_item'),
  \ 'options': '--ansi'
  \ }))
endfunction

function! s:open_quickfix_item(line)
  let items = getqflist()
	let item = items[split(a:line, '	')[0]]
  execute item.bufnr . 'buffer'
  call cursor(item.lnum, item.col)
endfunction

