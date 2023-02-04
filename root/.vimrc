set nocp
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype indent on
" filetype plugin on  

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

set nobackup       "no backup files
set nowritebackup  "only in case you don't want a backup file while editing
set noswapfile     "no swap files

""""""""""""""""""""""""""""""
"indent and tab
""""""""""""""""""""""""""""""
set smarttab
set autoindent
set smartindent
set cindent

augroup indent2
    autocmd!
    autocmd FileType cpp,vim,tex setlocal noexpandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup end
augroup python
    autocmd!
    autocmd FileType python setlocal noexpandtab tabstop=4
augroup end

augroup markdown 
    autocmd!
    autocmd FileType markdown setlocal noexpandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup end

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

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" nnoremap <BS> X

set t_Co=256
set t_ut=
hi debugPC term=reverse ctermbg=4 guibg=darkblue

autocmd Filetype c,cpp packadd termdebug
let g:termdebug_wide = 1

" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1

" RunCode
autocmd FileType c :command! -nargs=0 RunCode :!cc % -o %:r && ./%:r
autocmd FileType cpp :command! -nargs=0 RunCode :!c++ % -o %:r && ./%:r
autocmd FileType python :command! -nargs=0 RunCode :!python3 %

nnoremap <Leader>rc :RunCode<CR>

" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,java,scala 	                 let b:comment_leader = '// '
  autocmd FileType sh,ruby,python,conf,fstab,gitconfig   let b:comment_leader = '# '
  autocmd FileType tex                                   let b:comment_leader = '% '
  autocmd FileType mail                                  let b:comment_leader = '> '
  autocmd FileType vim                                   let b:comment_leader = '" '
augroup end

" a sed (s/what/towhat/where) command changing ^ (start of line) to the correctly set comment character based on the type of file you have opened 
" as for the silent thingies they just suppress output from commands. 
" :nohlsearch stops it from highlighting the sed search
noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

function GetVisualSelection()
	  " https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function ShowQuickfixListIfNotEmpty()
	let length = len(getqflist())
	if length > 1
		copen
	elseif length == 1
		copen
		ccl
	elseif length == 0
		echo 'empty quickfix list'
	endif
endfunction

function VimGrepFindWord(word)
	if &filetype == 'c' || &filetype == 'cpp'
		let extention = '**/*.c **/*.cpp **/*.cc **/*.h'
	elseif &filetype == 'python'
		let extention = '**/*.py'
	elseif &filetype == 'go'
		let extention = '**/*.go'
	else
		let extention = '**'
	endif
	silent exe 'silent! vimgrep' '/\<'.a:word.'\>/' extention
  call ShowQuickfixListIfNotEmpty()
endfunction

nnoremap <silent> <leader>fw :call VimGrepFindWord(expand("<cword>"))<CR>
vnoremap <silent> <leader>fw :call VimGrepFindWord(GetVisualSelection())<CR>
command! -nargs=1 Vimfw call VimGrepFindWord(<q-args>)

function VimGrepFindType(word)
	call setqflist([])
	if &filetype == 'c'	
		silent exe 'silent! vimgrepadd' '/\<struct '.a:word.'\>/' '**/*.c' '**/*.h'
	  silent exe 'silent! vimgrepadd' '/\<union '.a:word.'\>/' '**/*.c' '**/*.h'
	elseif &filetype == 'cpp'
	  silent! exe 'silent! vimgrepadd' '/\<struct '.a:word.'\>/' '**/*.cpp' '**/*.cc' '**/*.h'
	  silent! exe 'silent! vimgrepadd' '/\<union '.a:word.'\>/' '**/*.cpp' '**/*.cc' '**/*.h'
	  silent! exe 'silent! vimgrepadd' '/\<class '.a:word.'\>/' '**/*.cpp' '**/*.cc' '**/*.h'
	elseif &filetype == 'python'
	  silent exe 'silent! vimgrepadd' '/\<class '.a:word.'\>/' '**/*.py'
	elseif &filetype == 'go'
	  silent exe 'silent! vimgrepadd' '/\<type '.a:word.'\>/' '**/*.go'
	else
		echo 'unsupport filetype: '.&filetype
		return
	endif
  call ShowQuickfixListIfNotEmpty()
endfunction

nnoremap <silent> <leader>fy :call VimGrepFindType(expand("<cword>"))<CR>
vnoremap <silent> <leader>fd :call VimGrepFindType(GetVisualSelection())<CR>
command! -nargs=1 Vimfy call VimGrepFindType(<q-args>)

function VimGrepFindDefinition(word)
	call setqflist([])
	if &filetype == 'cpp' || &filetype == 'c'
		silent! exe 'silent! vimgrepadd' '/\<'.a:word.'(\(\w\|,\|\s\|\r\|\n\)\{-})\(\s\|\r\|\n\)\{-}{/' '**/*.cpp' '**/*.cc' '**/*.h'
	elseif &filetype == 'python'
		silent! exe 'silent! vimgrepadd' '/\<def '.a:word.'(/' '**/*.py'
	elseif &filetype == 'go'
		silent! exe 'silent! vimgrepadd' '/\<func '.a:word.'(/' '**/*.go'
	else
		echo 'unsupport filetype: '.&filetype
		return
	endif
  call ShowQuickfixListIfNotEmpty()
endfunction

nnoremap <silent> <leader>fd :call VimGrepFindDefinition(expand("<cword>"))<CR>
vnoremap <silent> <leader>fd :call VimGrepFindDefinition(GetVisualSelection())<CR>
command! -nargs=1 Vimfd call VimGrepFindDefinition(<q-args>)

" vim.fandom.com/wiki/Searching_for_files
" find files and populate the quickfix list
function FindFiles(filename)
  let error_file = tempname()
  silent exe '!find . -name "*'.a:filename.'*" | xargs file | sed "s/:/:1:/" > '.error_file
  set errorformat=%f:%l:%m
  exe "cfile ". error_file
  call ShowQuickfixListIfNotEmpty()
  call delete(error_file)
endfunction
command! -nargs=1 Fd call FindFiles(<q-args>)

" quickfix window
nnoremap <silent> co :copen<CR>
nnoremap <silent> cn :cn<CR>
nnoremap <silent> cp :cp<CR>
nnoremap <silent> ccl :ccl<CR>

helptags ~/.vim/doc
source ~/vimrc.d/markdown.vim
source ~/vimrc.d/plugin.vim
