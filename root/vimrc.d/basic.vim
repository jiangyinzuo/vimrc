set nocp "no Vi-compatible
set history=500 " Sets how many lines of history VIM has to remember

" Enable filetype plugins
filetype indent on
filetype plugin on  

syntax on "语法高亮显示
set encoding=utf-8
set number "显示行号
set showmatch  " 输入），}时，光标会暂时的回到相匹配的（，{。如果没有相匹配的就发出错误信息的铃声
set backspace=indent,eol,start "indent: BS可以删除缩进; eol: BS可以删除行末回车; start: BS可以删除原先存在的字符
set hidden " 未保存文本就可以隐藏buffer
set cmdheight=1 " cmd行高1
set wildmenu " command自动补全时显示菜单
set wildmode=list:full " command自动补全时显示整个列表
set wildignore=.git,build
set path=.,, " 当前目录和当前文件所在目录
set updatetime=700 " GitGutter更新和自动保存.swp的延迟时间
set timeoutlen=3000 " key map 超时时间

" set autowrite " 自动保存
set cursorline " 高亮当前行

set hlsearch " Highlight search results
set incsearch " 输入搜索内容时就显示搜索结果
set magic "模式匹配时 ^ $ . * ~ [] 具有特殊含义
set lazyredraw " 不要在宏的中间重绘屏幕。使它们更快完成。

set nobackup       "no backup files
set nowritebackup  "only in case you don't want a backup file while editing
set noswapfile     "no swap files

""""""""""""""""""""""""""""""
"indent and tab
""""""""""""""""""""""""""""""
set smarttab
set autoindent " 跟随上一行的缩进方式
set smartindent " 以 { 或cinword变量开始的行（if、while...），换行后自动缩进

augroup indent2
    autocmd!
    autocmd FileType cpp,vim,tex,markdown,html,sh,zsh,json,lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup end
augroup indent4
    autocmd!
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup end

