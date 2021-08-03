" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype indent on
filetype plugin on  
filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
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

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

nnoremap <BS> X


" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'https://hub.fastgit.org/tpope/vim-surround.git'

Plug 'https://hub.fastgit.org/mg979/vim-visual-multi.git', {'branch': 'master'}

Plug 'https://hub.fastgit.org/SirVer/ultisnips.git'
Plug 'https://hub.fastgit.org/honza/vim-snippets.git'
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger="<C-Right>"
let g:UltiSnipsJumpForwardTrigger="<Left>"
let g:UltiSnipsJumpBackwardTrigger="<Right>"

" Automatically adjusts tab indent
Plug 'https://hub.fastgit.org/tpope/vim-sleuth.git'

Plug 'https://hub.fastgit.org/tpope/vim-unimpaired.git'

Plug 'https://hub.fastgit.org/vim-airline/vim-airline.git'
Plug 'https://hub.fastgit.org/vim-airline/vim-airline-themes.git'
let g:airline_theme='cool'
let g:airline#extensions#tabline#formatter = 'unique_tail'

Plug 'https://hub.fastgit.org/tomasiser/vim-code-dark.git'

" similar plugin: mhinz/vim-signify
Plug 'https://hub.fastgit.org/airblade/vim-gitgutter.git'

if has('nvim')
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
Plug 'Shougo/defx.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
endif

" Automatically generate tags
Plug 'https://hub.fastgit.org/ludovicchabant/vim-gutentags.git'
Plug 'https://hub.fastgit.org/skywind3000/gutentags_plus.git'
source ~/vimrc.d/tag_config.vim

Plug 'https://hub.fastgit.org/bfrg/vim-cpp-modern.git'

" Enable function highlighting (affects both C and C++ files)
let g:cpp_function_highlight = 1

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

Plug 'https://hub.fastgit.org/rust-lang/rust.vim.git', {'for': 'rust' }
let g:rustfmt_autosave = 1

Plug 'https://hub.fastgit.org/python-mode/python-mode.git', { 'for': 'python', 'branch': 'develop' }
Plug 'https://hub.fastgit.org/fatih/vim-go.git', { 'for': 'go', 'do': ':GoUpdateBinaries' }
Plug 'https://hub.fastgit.org/artur-shaik/vim-javacomplete2.git', { 'for': 'java'}

Plug 'https://hub.fastgit.org/ycm-core/YouCompleteMe.git'
source ~/vimrc.d/ycm_config.vim

" don't select the first item.
set completeopt=menu,menuone,noselect,noinsert

" suppress annoy messages.
set shortmess+=c

Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
let g:Lf_ShowDevIcons = 0

Plug 'Yohannfra/Vim-Goto-Header'
let g:goto_header_use_find = 1 " By default it's value is 0
let g:goto_header_open_in_new_tab = 1

Plug 'liuchengxu/vista.vim'
let g:vista_executive_for = {
  \ 'c': 'coc',
  \ 'cpp': 'coc',
  \ 'rust': 'coc',
  \ 'go': 'coc',
  \ 'python': 'coc',
  \ 'java': 'coc',
  \ }

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
source ~/vimrc.d/coc_config.vim

Plug 'dense-analysis/ale'
source ~/vimrc.d/ale_config.vim

Plug 'https://hub.fastgit.org/puremourning/vimspector.git'
let g:vimspector_enable_mappings = 'HUMAN'

" Initialize plugin system
call plug#end()

:packadd termdebug
let g:termdebug_wide=1

set t_Co=256
set t_ut=
:colorscheme codedark
hi debugPC term=reverse ctermbg=4 guibg=darkblue
source ~/vimrc.d/defx_config.vim

