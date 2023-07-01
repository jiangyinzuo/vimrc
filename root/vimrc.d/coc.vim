" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" coc-snippets 不如coc-ultisnips配合UltiSnips插件好用
" 其它可选coc插件(有更好的vim插件可用)：
" coc-lists(buffer, grep, lines, mru, quickfix, tags, files等列表源 => fzf.vim和leaderf
" coc-git   => gitgutter lazygit
" coc-pairs => auto-pairs插件暂时不需要auto-pair补全
" other sources: https://github.com/neoclide/coc-sources
" Reference: https://github.com/neoclide
"
" 语法类插件（不好用）：
" coc-ltex依赖ltex-ls LSP
" 手动安装ltex-ls：前往https://github.com/valentjn/ltex-ls/releases下载并解压缩，解压后的目录位置类似
" ~/.vim/coc/extensions/node_modules/coc-ltex/lib/ltex-ls-15.2.0
" coc-grammarly
"
" clangd:
" 可以使用coc.nvim自带的支持（:CocConfig添加languageserver配置），也可以下载coc-clangd插件(clangd.enabled: true)，两者不能同时使用
"
" coc-marksman: 需要在根目录放一份.marksman.toml
let g:coc_initial_global_extensions = ['coc-lists', 'coc-ultisnips', 'coc-json', 'coc-vimtex', 'coc-texlab', 'coc-sh', 'coc-rust-analyzer', 'coc-clangd', 'coc-pyright', 'coc-java', 'coc-java-debug', 'coc-go', 'coc-dictionary', '@yaegassy/coc-marksman']
let g:coc_global_extensions = g:coc_initial_global_extensions
let g:coc_filetype_map = {'tex': 'latex'}
let g:coc_data_home = '~/.vim/coc'

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

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Apply the most preferred quickfix code action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use K to show documentation in preview window.
nnoremap <silent> <leader>K :call <SID>show_documentation()<CR>

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>fmt <Plug>(coc-format)

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OrganizeImports   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" https://github.com/neoclide/coc.nvim/wiki/Multiple-cursors-support
nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-d> <Plug>(coc-cursors-word)
xmap <silent> <C-d> <Plug>(coc-cursors-range)

" Mappings for CoCList
" Do default action for next item
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>

