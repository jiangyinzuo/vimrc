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
set wildmenu " command自动补全时显示菜单
set updatetime=700 " GitGutter更新和自动保存.swp的延迟时间
set timeoutlen=3000 " key map 超时时间

" 设置状态行-----------------------------------
" 设置状态行显示常用信息
" %F 完整文件路径名
" %m 当前缓冲被修改标记
" %m 当前缓冲只读标记
" %h 帮助缓冲标记
" %w 预览缓冲标记
" %Y 文件类型
" %b ASCII值
" %B 十六进制值
" %l 行数
" %v 列数
" %p 当前行数占总行数的的百分比
" %L 总行数
" %{...} 评估表达式的值，并用值代替
" %{"[fenc=".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?"+":"")."]"} 显示文件编码
" %{&ff} 显示文件类型
" 链接：https://zhuanlan.zhihu.com/p/532430825
set laststatus=2
set statusline=%1*%F%m%r%h%w%=\ %2*\ %Y\ %3*%{\"\".(\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\").\"\"}\ %4*[%l,%v]\ %5*%p%%\ \|\ %6*%LL

if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number " 合并git状态与行号
else
  set signcolumn=yes " 同时显示git状态和行号
endif

" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" Set to auto read when a file is changed from the outside
set autoread
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
			\ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
			\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl Noneau FocusGained,BufEnter * checktime

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
    autocmd FileType cpp,vim,tex,markdown,html,sh,zsh setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup end
augroup python
    autocmd!
    autocmd FileType python setlocal tabstop=4 softtabstop=4
augroup end

""""""""""""""""""""""""""""""

if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""" termdebug
set t_Co=256
set t_ut=
hi debugPC term=reverse ctermbg=4 guibg=darkblue

autocmd Filetype c,cpp packadd termdebug
let g:termdebug_wide = 1

"""""""""""""""""""""""""""""""""""""""""""""""""" Netrw Plugin
"  open explorer :Ex :Sex :Vex
" close explorer :Rex
"
" do not load netrw
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1
let g:netrw_browse_split = 0 " open the file using netrw buffer
let g:netrw_liststyle = 3 " tree style listing
let g:netrw_preview = 0 " preview window horizontally

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
" fzf.vim defines :Rg
command! -nargs=1 Myrg call Ripgrep(<q-args>)

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

" Example:
" :e+22 ~/.vimrc
command! -nargs=0 VimExeLine exe getline(".")

" https://www.zhihu.com/question/30782510/answer/70078216
nnoremap zp :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>:set foldmethod=manual<CR><CR>
" unfold all: zR

set makeprg=make

let s:has_vimrcd = isdirectory(expand('~/vimrc.d'))

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                    TAGS                                      "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 递归向上层寻找tags文件
" set tags=tags;/

" Reference: https://cscope.sourceforge.net/cscope_maps.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:tags_use_cscope = 0
let s:tags_use_gtags = 0

" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope") && s:tags_use_cscope

	""""""""""""" Standard cscope/vim boilerplate
	
	" reset cscope:
	" :cs reset
	
	" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
	set cscopetag

	" check cscope for definition of a symbol before checking ctags: set to 1
	" if you want the reverse search order.
	set csto=0

	" add any cscope database in current directory
	if filereadable("cscope.out")
		cs add cscope.out  
		" else add the database pointed to by environment variable 
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif

	" show msg when any other cscope db added
	set cscopeverbose

	""""""""""""" My cscope/vim key mappings
	"
	" The following maps all invoke one of the following cscope search types:
	"
	"   's'   symbol: find all references to the token under cursor
	"   'g'   global: find global definition(s) of the token under cursor
	"   'c'   calls:  find all calls to the function name under cursor
	"   't'   text:   find all instances of the text under cursor
	"   'e'   egrep:  egrep search for the word under cursor
	"   'f'   file:   open the filename under cursor
	"   'i'   includes: find files that include the filename under cursor
	"   'd'   called: find functions that function under cursor calls

	" nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	" nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
	" nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>

	if s:tags_use_gtags && s:has_vimrcd
		" use gtags-cscope
		set csprg=gtags-cscope
		source ~/vimrc.d/gtags-cscope.vim " https://www.gnu.org/software/global/globaldoc_toc.html#Gtags_002dcscope
	endif
elseif s:tags_use_gtags && s:has_vimrcd
	source ~/vimrc.d/gtags.vim " https://www.gnu.org/software/global/globaldoc_toc.html#Vim-editor
	nnoremap <C-]> :Gtags -d <C-R>=expand("<cword>")<CR><CR>
endif

if isdirectory(expand('~/.vim/doc'))
	helptags ~/.vim/doc
endif

if s:has_vimrcd
  source ~/vimrc.d/plugin.vim
endif

if !exists("g:plugs") || !has_key(g:plugs, 'coc.nvim')
	" https://zhuanlan.zhihu.com/p/106309525
	if has("autocmd") && exists("+omnifunc")
		autocmd Filetype * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
	endif
endif
