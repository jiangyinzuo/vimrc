" use <C-x> to auto complete github copilot
" imap <silent><script><expr> <C-x> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true

" Load the plugin on InsertEnter
" autocmd InsertEnter * ++once call plug#load('copilot.vim')
imap <M-p> <Plug>(copilot-previous)
imap <M-n> <Plug>(copilot-next)
imap <M-x> <Plug>(copilot-dismiss)
imap <M-w> <Plug>(copilot-accept-word)
imap <M-l> <Plug>(copilot-accept-line)
imap <M-s> <Plug>(copilot-suggest)
" copilot workspace folder
autocmd BufReadPost,BufNewFile * ++once let b:workspace_folder = asyncrun#current_root()
