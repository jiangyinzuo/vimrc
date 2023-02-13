" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" coc-snippets 不如coc-ultisnips配合UltiSnips插件好用
" 其它可选coc插件(有更好的vim插件可用)：
" coc-lists(buffer, grep, lines, mru, quickfix, tags, files等列表源 => fzf.vim和leaderf
" coc-git   => gitgutter lazygit
" coc-pairs => auto-pairs插件暂时不需要auto-pair补全
" other sources: https://github.com/neoclide/coc-sources
" Reference: https://github.com/neoclide
let g:coc_global_extensions = ['coc-vimtex', 'coc-ultisnips']

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> <leader>K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

