" run
" :source %
" to update
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" source ~/vimrc.d/startify.vim
" Plug 'markonm/traces.vim'

Plug 'tomasiser/vim-code-dark'

" Plug 'MattesGroeger/vim-bookmarks'
" Plug 'vim-airline/vim-airline'

" Plug 'ojroques/vim-oscyank', {'branch': 'main'}
" vnoremap <leader>c :OSCYank<CR>

" source ~/vimrc.d/nerdtree.vim

" similar plugin: mhinz/vim-signify
" Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-fugitive'

source ~/vimrc.d/leaderf.vim
source ~/vimrc.d/fzf.vim

source ~/vimrc.d/coc.vim

" source ~/vimrc.d/cpp.vim

Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1

source ~/vimrc.d/latex.vim

" source ~/vimrc.d/go.vim

" :CocInstall coc-snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Games
" Plug 'vim/killersheep'
" Plug 'johngrib/vim-game-snake'

" Initialize plugin system
call plug#end()

colorscheme codedark
