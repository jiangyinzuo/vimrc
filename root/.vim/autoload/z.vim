function s:z(cmd, query, sink, option_list, prompt)
	call fzf#run(fzf#wrap({'source': a:cmd, 'sink': a:sink, 'options': a:option_list + ['--query', a:query, '--prompt', a:prompt . a:sink . ' >', '--color', 'hl:148,hl+:190']}))
endfunction

" https://gist.github.com/jiangyinzuo/d9c985999f76864ac192edfdacdadcce
function z#Z(query, sink)
	let l:cmd = "awk -f " . $VIMRC_ROOT . "/z.awk regex=" . a:query . " ~/.z "
	call s:z(l:cmd, a:query, a:sink, [], 'Z | ')
endfunction

function z#Zt(query, sink)
	let l:cmd = 'sort --field-separator="|" --key=3n ~/.z ' . ' | awk -f ' . $VIMRC_ROOT . '/z.awk regex=' . a:query
	call s:z(l:cmd, a:query, a:sink, ['+s', '--tac'], 'Z -t | ')
endfunction
