set nocp "no Vi-compatible
set history=500 " Sets how many lines of history VIM has to remember

" Enable filetype plugins
filetype indent on
filetype plugin on  

syntax on "语法高亮显示
set mouse=a
set encoding=utf-8
set number "显示行号
set showmatch  " 输入），}时，光标会暂时的回到相匹配的（，{。如果没有相匹配的就发出错误信息的铃声
set backspace=indent,eol,start "indent: BS可以删除缩进; eol: BS可以删除行末回车; start: BS可以删除原先存在的字符
set hidden " 未保存文本就可以隐藏buffer
set cmdheight=1 " cmd行高1
set updatetime=700 " GitGutter更新和自动保存.swp的延迟时间
set timeoutlen=3000 " key map 超时时间

if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number " 合并git状态与行号
else
  set signcolumn=yes " 同时显示git状态和行号
endif

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

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
    autocmd FileType cpp,vim,tex,markdown,html setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup end
augroup python
    autocmd!
    autocmd FileType python setlocal tabstop=4 softtabstop=4
augroup end

""""""""""""""""""""""""""""

if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
endif

set t_Co=256
set t_ut=
hi debugPC term=reverse ctermbg=4 guibg=darkblue

autocmd Filetype c,cpp packadd termdebug
let g:termdebug_wide = 1

" Netrw Plugin
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1

" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,java,scala 	                 let b:comment_leader = '// '
  autocmd FileType sh,ruby,python,conf,fstab,gitconfig   let b:comment_leader = '# '
  autocmd FileType tex                                   let b:comment_leader = '% '
  autocmd FileType mail                                  let b:comment_leader = '> '
  autocmd FileType vim                                   let b:comment_leader = '" '
augroup end

" https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim
" A sed (s/what/towhat/where) command changing ^ (start of line) to the correctly set comment character based on the type of file you have opened 
" As for the silent thingies they just suppress output from commands. 
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

" Reference vim.fandom.com/wiki/Searching_for_files
" find files and populate the quickfix list
function FindFiles(filename)
	cexpr system('find . -name "*'.a:filename.'*" | xargs file | sed "s/:/:1:/"')
  set errorformat=%f:%l:%m
  call ShowQuickfixListIfNotEmpty()
endfunction
command! -nargs=1 Fd call FindFiles(<q-args>)

function Ripgrep(args)
	cexpr system('rg --vimgrep ' . a:args)
  call ShowQuickfixListIfNotEmpty()
endfunction
command! -nargs=1 Rg call Ripgrep(<q-args>)

"""""""""""""""""""""""""""""""""""""" quickfix window
nnoremap <silent> co :copen<CR>
nnoremap <silent> cn :cn<CR>
nnoremap <silent> cp :cp<CR>
nnoremap <silent> ccl :ccl<CR>

vnoremap <silent> <leader>t :term ++open ++rows=9<CR>
nnoremap <silent> <leader>t :term ++rows=9<CR>
tnoremap <silent> <leader>t <C-W>:hide<CR>

function CExprSystem(args)
	cexpr system(a:args)
  call ShowQuickfixListIfNotEmpty()
endfunction
command! -nargs=1 CExprsys call CExprSystem(<q-args>)
""""""""""""""""""""""""""""""""""""""""""""""""""""""

helptags ~/.vim/doc
source ~/vimrc.d/tags.vim
source ~/vimrc.d/plugin.vim
