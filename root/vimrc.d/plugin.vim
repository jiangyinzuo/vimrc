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

" source ~/vimrc.d/coc.vim

source ~/vimrc.d/cpp.vim
" source ~/vimrc.d/go.vim
source ~/vimrc.d/markdown.vim
source ~/vimrc.d/latex.vim

" :CocInstall coc-snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

source ~/vimrc.d/asynctasks.vim

" Initialize plugin system
call plug#end()

colorscheme codedark
