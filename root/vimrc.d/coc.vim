" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release', 'on': []}
augroup load_coc
    autocmd!
    autocmd BufWinEnter * call plug#load('coc.nvim') | autocmd! load_coc | autocmd CursorHold * silent call CocActionAsync('highlight')
	" Highlight the symbol and its references when holding the cursor.
augroup END

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
let g:coc_initial_global_extensions = ['coc-ultisnips', 'coc-json', 'coc-vimtex', 'coc-sh', 'coc-rust-analyzer', 'coc-clangd', 'coc-pyright', 'coc-java', 'coc-java-debug', 'coc-go', 'coc-dictionary', '@yaegassy/coc-marksman']
let g:coc_global_extensions = g:coc_initial_global_extensions
let g:coc_filetype_map = {'tex': 'latex'}
let g:coc_data_home = '~/.vim/coc'

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

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>fmt <Plug>(coc-format)
