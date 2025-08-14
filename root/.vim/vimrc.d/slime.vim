" ocaml utop在第一次send时可能会失败，需要再send一次，或提前打开:SlimeConfig
let g:slime_target = "vimterminal"
let g:slime_no_mappings = 1

xmap <leader>sp <Plug>SlimeRegionSend
nmap <leader>sl <Plug>SlimeLineSend
nmap <leader>sp <Plug>SlimeParagraphSend
nmap <leader>sc <Plug>SlimeSendCell

