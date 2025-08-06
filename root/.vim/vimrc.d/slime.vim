" ocaml utop在第一次send时可能会失败，需要再send一次，或提前打开:SlimeConfig
let g:slime_target = "vimterminal"
let g:slime_no_mappings = 1

function s:map_sender(sender)
	if a:sender == 'slime'
		xmap <leader>sp <Plug>SlimeRegionSend
		nmap <leader>sl <Plug>SlimeLineSend
		nmap <leader>sp <Plug>SlimeParagraphSend
		nmap <leader>sc <Plug>SlimeSendCell
	elseif a:sender == 'jupyter' || a:sender == 'jupyter-matplotlib'
		:JupyterConnect
		nnoremap <leader>sc :JupyterSendCell<CR>
		nnoremap <leader>si :JupyterSendCode ''<Left>
		nnoremap <leader>sp :JupyterSendRange<CR>
		xnoremap <leader>sp :JupyterSendRange<CR>
		if a:sender == 'jupyter-matplotlib'
			let timer = timer_start(1500, function('jupyter_custom#MatplotlibInit'))
		endif
		echom '<leader>sc -> send cell | <leader>si -> send code | <leader>sp -> send range'
	endif
endfunction
function s:sender_list(ArgLead, CmdLine, CursorPos)
	return filter(['jupyter', 'jupyter-matplotlib', 'slime'], 'stridx(v:val, a:ArgLead) == 0')
endfunction
command -nargs=1 -complete=customlist,s:sender_list MapSender call s:map_sender(<f-args>)
MapSender slime
