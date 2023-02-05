" run
" :source %
" to update
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'markonm/traces.vim'
Plug 'tomasiser/vim-code-dark'

" Plug 'MattesGroeger/vim-bookmarks'

" Plug 'ojroques/vim-oscyank', {'branch': 'main'}
" vnoremap <leader>c :OSCYank<CR>

Plug 'airblade/vim-gitgutter'

source ~/vimrc.d/leaderf.vim
source ~/vimrc.d/fzf.vim

source ~/vimrc.d/coc.vim

" source ~/vimrc.d/cpp.vim
" source ~/vimrc.d/go.vim

Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1

source ~/vimrc.d/latex.vim

" :CocInstall coc-snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" 可选插件任务系统 skywind3000/asynctask.vim
Plug 'skywind3000/asyncrun.vim'

" Initialize plugin system
call plug#end()

colorscheme codedark
