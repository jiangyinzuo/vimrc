function! fzf#tabs#FzfTabs()
  let tab_list = []
  let tcount = tabpagenr('$')

  " Generate the list of all tabs with their windows
  for i in range(1, tcount)
    let win_list = []
    for j in range(1, len(tabpagebuflist(i)))
      let bufnr = tabpagebuflist(i)[j - 1]
      let filename = bufname(bufnr)
      let win_list += [filename]
    endfor
    let tab_list += [printf("Tab %d: %s", i, join(win_list, ' | '))]
  endfor

  " Use fzf#run to select the tab
  call fzf#run({
        \ 'source': tab_list,
        \ 'sink': function('s:SwitchToTab'),
        \ 'options': '--prompt="Select Tab> " --preview-window=up:1'
        \ })
endfunction

function! s:SwitchToTab(tab)
  let match = matchlist(a:tab, 'Tab \(\d\+\):')
  let tabnr = match[1]
  execute 'tabn ' . tabnr
endfunction
