" fix bug 'Auto jump to the first line after exit from the floating
" window of CocFzfLocation'
" https://github.com/antoinemadec/coc-fzf/issues/113
let g:coc_fzf_location_delay = 20

let g:coc_filetype_map = {'tex': 'latex'}
autocmd FileType tex ++once call coc#config('texlab.latexindent.local', $VIMRC_ROOT . "/latexindent.yaml")
autocmd FileType lua ++once call coc#config('stylua.styluaPath', $HOME . '/.cargo/bin/stylua')
autocmd FileType c,cpp,cuda ++once call coc_clang#setup_coc_clangd()
autocmd FileType python ++once call coc#config('python.formatting.provider', g:python_formatter)
function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

augroup coc_action
  autocmd!
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

augroup coc_mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> <leader>da <Plug>(coc-diagnostic-info)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
" See Also: :HelpRg mapping in root/.vim/vimrc.d/fzf.vim
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> <leader>K :call <SID>show_documentation()<CR>

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>ac  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>re <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>fmt <Plug>(coc-format)
xmap <leader>fmt <Plug>(coc-format-selected)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
" xmap 是用于Visual模式（不包括Select模式）的映射。
" omap 用于Operator-pending模式的映射。这种映射在你输入一个操作符（如 d 删除，y 复制，c 改变等）后，但在你完成整个操作（比如指定一个移动命令或文本对象）之前，生效。
" daf  删除当前函数文本对象
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')
" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OrganizeImports   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Use coc-lists instead of custom mksession.vim
" https://github.com/neoclide/coc-lists
command! -nargs=0 Mksession :CocCommand session.save
command! -nargs=0 Loadsession :CocCommand session.load

" :h coc-tree
command! -nargs=0 CocOutgoingCalls :CocCommand document.showOutgoingCalls
command! -nargs=0 CocIncomingCalls :CocCommand document.showIncomingCalls
command! -nargs=0 CocSubTypes :call CocAction('showSubTypes')
command! -nargs=0 CocSuperTypes :call CocAction('showSuperTypes')

" https://github.com/neoclide/coc.nvim/wiki/Multiple-cursors-support
" vim-visual-multi is too complex!!!
" SpecialKey在coc多光标模式下不会高亮，如有需要，可以在执行多光标前执行
" :setnolist
" 在多光标操作结束后再执行
" :setlist
nmap <silent> <C-c> :<C-u>silent! call CocAction('cursorsSelect', bufnr('%'), 'position', 'n')<CR>
nmap <silent> <C-j> j:<C-u>silent! call CocAction('cursorsSelect', bufnr('%'), 'position', 'n')<CR>
nmap <silent> <C-k> k:<C-u>silent! call CocAction('cursorsSelect', bufnr('%'), 'position', 'n')<CR>
" nmap <silent> <C-d> <Plug>(coc-cursors-word)
" xmap <silent> <C-d> <Plug>(coc-cursors-range)

" Mappings for CoCList
" Show all diagnostics
" nnoremap <silent><nowait> <leader>da  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <leader>ext  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <leader>cmd  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <leader>out  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <leader>sym  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>

autocmd filetype coctree nmap <buffer> <F1> :h coc-tree<CR>

" autocmd filetype coc-explorer nmap <buffer> <F1> :h coc-explorer<CR>
" autocmd filetype coc-explorer nmap <buffer> gx :call coc_custom#NetrwGxHandler()<CR>
" nnoremap <silent><nowait> <leader>e :<C-u>CocCommand explorer<CR>

hi CocCursorRange cterm=reverse guibg=#ebdbb2 guifg=#b16286
