" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype indent on
filetype plugin on
filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

"Always show current position set ruler " Height of the command bar set cmdheight=2 " Ignore case when searching set ignorecase " When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Don't redraw while executing macros (good performance config)
set lazyredraw

set smarttab
set autoindent

set mouse=a
set encoding=utf-8

"语法高亮显示
syntax on

"显示行号
set number

" Show matching brackets when text indicator is over them
set showmatch

"enable backspace
set backspace=indent,eol,start

"设置GVim字体
set guifont=LiberationMono\ 14
"隐藏GVim菜单栏
set guioptions-=m
"隐藏GVim工具栏
set guioptions-=T

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

nnoremap <BS> X

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'tomasiser/vim-code-dark'
Plug 'MattesGroeger/vim-bookmarks'

" similar plugin: mhinz/vim-signify
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
""""""""""""""""""""""""""""""
"Leaderf settings
""""""""""""""""""""""""""""""
"文件搜索
nnoremap <silent> <c-f> :Leaderf file<CR>

"历史打开过的文件
nnoremap <silent> <c-h> :Leaderf mru<CR>

"Buffer
nnoremap <silent> <c-b> :Leaderf buffer<CR>

"Based on ripgrep
nnoremap <silent> <Leader>rg :Leaderf rg --nameOnly<CR>

let g:Lf_ShowDevIcons = 0
let g:Lf_RgConfig = ["--glob=!deps/* --glob=!build/*"]
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn', '.git', '.cache', 'deps', 'build'],
    \ 'file': []
    \}
""""""""""""""""""""""""""""""

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
source ~/vimrc.d/coc_config.vim

Plug 'bfrg/vim-cpp-modern'
source ~/vimrc.d/cpp_config.vim

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" source ~/vimrc.d/go_config.vim

" Initialize plugin system
call plug#end()

" source ~/vimrc.d/termdebug_config.vim
