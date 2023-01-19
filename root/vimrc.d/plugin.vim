" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" source ~/vimrc.d/startify.vim
" Plug 'markonm/traces.vim'

" Plug 'tomasiser/vim-code-dark'
" colorscheme codedark

" Plug 'MattesGroeger/vim-bookmarks'
" Plug 'vim-airline/vim-airline'

" Plug 'ojroques/vim-oscyank', {'branch': 'main'}
" vnoremap <leader>c :OSCYank<CR>

" source ~/vimrc.d/nerdtree.vim

" similar plugin: mhinz/vim-signify
" Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-fugitive'

" source ~/vimrc.d/leaderf.vim
source ~/vimrc.d/fzf.vim

" source ~/vimrc.d/coc.vim

" source ~/vimrc.d/cpp.vim

source ~/vimrc.d/markdown.vim

" source ~/vimrc.d/go.vim

" Initialize plugin system
call plug#end()

