" Single .vimrc file. The complete vimrc is `root/.vim/vimrc`.
" Custom vim configuration file `~/config_single_vimrc.vim`
set number "显示行号
if has('autocmd') " vim-tiny does not have autocmd
	set nocp "no Vi-compatible
	let g:mapleader = ' '
	set modeline " 开启模式行, 读取文件开头结尾类似于 /* vim:set ts=2 sw=2 noexpandtab: */ 的配置
	set exrc " 读取当前文件夹的.vimrc
	if has("patch-7.4.1649")
		packadd! matchit
	endif
	if exists('&viminfofile') && !has('nvim')
		set viminfofile=$HOME/.vim/.viminfo
		" 保留50个marks
		" 每个寄存器保存50行内容
		" 保存50行搜索历史
		" 保存50行命令历史
		" 禁止hlsearch
		" 禁止保存超过10kb的寄存器内容
		" 保存0-9，A-Zmark
		set viminfo='50,<50,/50,:50,h,s10,f100
	endif
	set history=500 " Sets how many lines of history VIM has to remember
	filetype indent on
	filetype plugin on
	syntax on "语法高亮显示
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=utf-8,ucs-bom,gbk,cp936,gb2312,gb18030 " vim自动探测fileencodeing的顺序列表
	set termencoding=utf-8
	set fileformats=unix,dos,mac " 文件格式
	set showmatch  " 输入），}时，光标会暂时的回到相匹配的（，{。如果没有相匹配的就发出错误信息的铃声
	set matchtime=1 " showmatch的时间0.1s
	set backspace=indent,eol,start "indent: BS可以删除缩进; eol: BS可以删除行末回车; start: BS可以删除原先存在的字符
	set hidden " 未保存文本就可以隐藏buffer
	set cmdheight=2 " cmd行高2, 减少hit-enter
	set wildmenu " command自动补全时显示菜单
	if v:version >= 802
		set wildoptions=pum " 显示popup window
	else
		set wildmode=list:full
	endif
	set wildignore=.git/*,build/*,.cache/*
	set updatetime=700 " GitGutter更新和自动保存.swp的延迟时间

	" https://www.skywind.me/blog/archives/2021
	set timeoutlen=3000 " key map 超时时间
	set ttimeout
	if $TMUX != ''
		set ttimeoutlen=30
	elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
		set ttimeoutlen=80
	endif

	set autowrite " 自动保存
	set scrolloff=7 " 光标离底部或顶部保持7行
	set hlsearch " Highlight search results
	set incsearch " 输入搜索内容时就显示搜索结果
	set magic "模式匹配时 ^ $ . * ~ [] 具有特殊含义
	set lazyredraw " 不要在宏的中间重绘屏幕。使它们更快完成。
	set dictionary+=/usr/share/dict/american-english
	set nobackup       "no backup files
	set nowritebackup  "only in case you don't want a backup file while editing
	set noswapfile     "no swap files
	" 会话不保存options, 防止重新set background=dark后，覆盖一些highlight设置
	if v:version >= 802
		set sessionoptions=curdir,globals,localoptions,resize,tabpages,terminal,winpos,winsize
	else
		set sessionoptions=curdir,globals,localoptions,resize,tabpages,winpos,winsize
	endif
	" 选中想格式化的段落后，可以用gq格式化
	" 设置textwidth，可以让文本格式化时自动换行
	autocmd Filetype tex setlocal textwidth=80
	""""""""""""""""""""""""""""""
	"indent and tab
	""""""""""""""""""""""""""""""
	set smarttab
	set autoindent " 跟随上一行的缩进方式
	" 不开启smartindent, 否则visual模式shift缩进多行时，行首非空白字符开头的注释不会跟着shift
	" set smartindent " 以 { 或cinword变量开始的行（if、while...），换行后自动缩进

	""" default indent
	" markdown在被默认vim runtime file设置为tabstop=4
	" :verbose set tabstop? shiftwidth? softtabstop?
	set tabstop=4 shiftwidth=4 softtabstop=4

	augroup equalprg_filetype
		autocmd!
		" autocmd FileType c,cpp setlocal equalprg=indent
		" autocmd FileType c,cpp setlocal equalprg=uncrustify\ -c\ .uncrustify.cfg\ --replace\ --no-backup
		autocmd FileType sql setlocal equalprg=sqlformat\ -k\ upper\ -r\ --indent_columns\ -
	augroup end

	autocmd FileType c,cpp,cuda,vim,tex,html,sh,zsh,json,lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
	" tex使用空格缩进
	autocmd FileType tex setlocal expandtab

	if v:version >= 901
		packadd! editorconfig
	endif

	" 显示空白字符
	" https://codepoints.net/U+23B5
	" set listchars=eol:⏎,tab:¦\ ,trail:␠,nbsp:⎵,extends:»,precedes:«
	set listchars=tab:¦\ ,trail:␠,nbsp:⎵,extends:»,precedes:«
	autocmd FileType man setlocal nolist
	" Enable :Man command
	runtime ftplugin/man.vim

	set list
	" set nowrap " 不折行
	set guifont=Monospace\ Regular\ 20

	if has("nvim-0.5.0") || has("patch-8.1.1564")
		set signcolumn=number " 合并git状态与行号
	elseif v:version >= 801
		set signcolumn=yes " 同时显示git状态和行号
	endif

	if v:version >= 801
		set conceallevel=2
		
		" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
		" Set to auto read when a file is changed from the outside
		set autoread
		" Triger `autoread` when files changes on disk
		" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
		" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
		autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

		" Notification after file change
		" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
		autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl Noneau FocusGained,BufEnter * checktime
	endif

	"""""""""""""""""""""""""""""""

	if has("patch-8.1.0360")
		set diffopt=vertical,filler,context:3,indent-heuristic,algorithm:patience,internal
	endif

	""""""""""""""""""""""""""""""""""""""""""""""""""""" termdebug
	set t_Co=256
	set t_ut=

	if has('nvim') || v:version >= 801
		autocmd Filetype c,cpp,rust,cuda packadd termdebug
		autocmd Filetype termdebug setlocal termwinsize=0*10000
		let g:termdebug_config = {}
		let g:termdebug_config['command'] = "gdb"
		" 设置一个较大的宽度，防止termdebug gdb窗口折行
		let g:termdebug_config['wide'] = 1
	endif

	""""""""""""""""""""""""""""""""""""""""""""""""""" Netrw Plugin
	"  open explorer :Ex :Sex :Vex
	" close explorer :Rex
	"
	" do not load netrw
	" let g:loaded_netrw = 1
	" let g:loaded_netrwPlugin = 1
	let g:netrw_browse_split = 0 " open the file using netrw buffer
	let g:netrw_liststyle = 3 " tree style listing
	let g:netrw_preview = 0 " preview window horizontally
	if exists('$WSLENV')
		let g:netrw_browsex_viewer="-"
	endif
	let g:netrw_hide = 1 " show not-hidden files
	let g:netrw_keepdir=0

	" see netrw-v
	" 新的窗口出现在当前窗口的右边
	set splitright
	let g:netrw_altv = 1
	let g:netrw_winsize = 20
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

	augroup jump_to_symbol
		autocmd!
		" See: https://stackoverflow.com/questions/12128678/vim-go-to-beginning-end-of-next-method
		" #gpt4-answer
		" jump to the previous function
		" 向后（b表示backward）搜索一个匹配特定模式的地方，这个模式是一个函数的开始位置。
		autocmd FileType c,cpp nnoremap <silent> [f :call search('\(\(if\\|for\\|while\\|switch\\|catch\)\_s*\)\@64<!(\_[^)]*)\_[^;{}()]*\zs{', "bw")<CR>
		" jump to the next function
		" 向前（w表示forward）搜索一个匹配特定模式的地方，这个模式是一个函数的开始位置。
		autocmd FileType c,cpp nnoremap <silent> ]f :call search('\(\(if\\|for\\|while\\|switch\\|catch\)\_s*\)\@64<!(\_[^)]*)\_[^;{}()]*\zs{', "w")<CR>
		" 搜索的模式是一个正则表达式，用来匹配不是在if, for, while, switch, 和catch后面的左花括号{，因为在C++中函数的定义是以左花括号开始的。
		" 需要注意的是，这个搜索模式可能并不完全精确，因为函数的定义还可能包含许多其他的复杂性，比如模板函数，函数指针，宏定义等等。对于一些简单的代码文件，这个方法通常可以工作得很好。
		" 这些配置会更好地在代码中快速导航，但如果你需要更精确地识别函数，你可能需要考虑使用一些更高级的插件，比如ctags,cscope等等。

		" Go 语言的函数定义是以 func 关键字开始的，所以我们可以使用这个关键字来搜索函数的开始位置。
		" 在这里，我们用 \< 和 \> 来指定词的边界，这样我们就可以准确地匹配func，而不是 func 作为其他词的一部分。bW 和 wW是搜索命令的标志，b 表示向后搜索，w 表示向前搜索，W 表示只匹配整个单词。
		autocmd FileType go nnoremap <silent> <buffer> [f :call search('\<func\>', "bW")<CR>
		autocmd FileType go nnoremap <silent> <buffer> ]f :call search('\<func\>', "wW")<CR>
		" 以上代码仅会简单地跳转到包含 func 关键字的行，不过如果你需要更精确或更高级的功能，你可能需要考虑使用一些专门为
		" Go 语言设计的 Vim 插件，例如 vim-go。这个插件为 Go语言提供了许多功能，包括代码导航、自动完成、代码格式化等等。
		" autocmd FileType python nnoremap <silent> <buffer> [f :call search('\<def\>', "bW")<CR>
		" autocmd FileType python nnoremap <silent> <buffer> ]f :call search('\<def\>', "wW")<CR>
		autocmd FileType rust nnoremap <silent> <buffer> [f :call search('\<fn\>', "bW")<CR>
		autocmd FileType rust nnoremap <silent> <buffer> ]f :call search('\<fn\>', "wW")<CR>
		autocmd FileType lua nnoremap <silent> <buffer> [f :call search('\<function\>', "bW")<CR>
		autocmd FileType lua nnoremap <silent> <buffer> ]f :call search('\<function\>', "wW")<CR>

		autocmd FileType c,cpp nnoremap <silent> <buffer> [t :call search('\<class\>\|\<struct\>\|\<enum\>\|\<typedef\>', "bW")<CR>
		autocmd FileType c,cpp nnoremap <silent> <buffer> ]t :call search('\<class\>\|\<struct\>\|\<enum\>\|\<typedef\>', "wW")<CR>
		autocmd FileType go nnoremap <silent> <buffer> [t :call search('\<type\>', "bW")<CR>
		autocmd FileType go nnoremap <silent> <buffer> ]t :call search('\<type\>', "wW")<CR>
		autocmd FileType rust nnoremap <silent> <buffer> [t :call search('\<struct\>\|\<enum\>\|\<type\>', "bW")<CR>
		autocmd FileType rust nnoremap <silent> <buffer> ]t :call search('\<struct\>\|\<enum\>\|\<type\>', "wW")<CR>
		" autocmd FileType python nnoremap <silent> <buffer> [t :call search('\<class\>', "bW")<CR>
		" autocmd FileType python nnoremap <silent> <buffer> ]t :call search('\<class\>', "wW")<CR>
	augroup END

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

	function FindWord(word)
		if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'cuda'
			let l:extension = '**/*.c* **/*.h*'
		else
			let l:extension = '**/*.' . expand('%:e')
		endif
		" <pattern>: 匹配整个单词
		exe 'vimgrep /\<'.a:word.'\>/ ' . l:extension
		call ShowQuickfixListIfNotEmpty()
	endfunction

	function FindType(word)
		" <pattern>: 匹配整个单词
		if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'cuda'
			exe 'vimgrep' '/\<\(struct\|union\|class\) '.a:word.'\>/' '**/*.c*' '**/*.h*'
		elseif &filetype == 'python'
			exe 'vimgrep' '/\<class '.a:word.'\>/' '**/*.py'
		elseif &filetype == 'go'
			exe 'vimgrep' '/\<type '.a:word.'\>/' '**/*.go'
		else
			echo 'unsupport filetype: '.&filetype
			return
		endif
		call ShowQuickfixListIfNotEmpty()
	endfunction

	function FindDefinitionFunction(word)
		if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'cuda'
			exe 'vimgrep' '/\<'.a:word.'\s*(/ **/*.c* **/*.h*'
		elseif &filetype == 'python'
			exe 'vimgrep' '/\<def '.a:word.'(/' '**/*.py'
		elseif &filetype == 'go'
			exe 'vimgrep' '/\<func '.a:word.'(/' '**/*.go'
		else
			echo 'unsupport filetype: '.&filetype
			return
		endif
		call ShowQuickfixListIfNotEmpty()
	endfunction

	function Ripgrep(args)
		cexpr system('rg --vimgrep ' . a:args)
		call ShowQuickfixListIfNotEmpty()
	endfunction

	" Reference: vim.fandom.com/wiki/Searching_for_files
	" find files and populate the quickfix list
	" :find :new :edit :open 只能找一个文件，需要配合wildmenu逐级搜索文件夹
	" :new 开新的window
	" :edit 在当前buffer
	" :open 无法使用通配符，不能使用wildmode
	" :next 可以打开多个文件
	function FindFiles(filename)
		cexpr system('find . -name "*'.a:filename.'*" | xargs file | sed "s/:/:1:/"')
		set errorformat=%f:%l:%m
		call ShowQuickfixListIfNotEmpty()
	endfunction

	function! ToggleQuickfix()
		if empty(filter(range(1, winnr('$')), 'getwinvar(v:val, "&buftype") == "quickfix"'))
			copen
		else
			cclose
		endif
	endfunction

	function SystemToQf(args)
		cexpr system(a:args)
		call ShowQuickfixListIfNotEmpty()
	endfunction

	nnoremap <silent> <leader>vw :call FindWord(expand("<cword>"))<CR>
	vnoremap <silent> <leader>vw :call FindWord(GetVisualSelection())<CR>
	command! -nargs=1 VimWord call FindWord(<q-args>)

	nnoremap <silent> <leader>vy :call FindType(expand("<cword>"))<CR>
	vnoremap <silent> <leader>vy :call FindType(GetVisualSelection())<CR>
	command! -nargs=1 VimType call FindType(<q-args>)

	nnoremap <silent> <leader>vd :call FindDefinitionFunction(expand("<cword>"))<CR>
	vnoremap <silent> <leader>vd :call FindDefinitionFunction(GetVisualSelection())<CR>
	command! -nargs=1 VimDef call FindDefinitionFunction(<q-args>)

	command! -nargs=1 SystemFindFiles call FindFiles(<q-args>)
	command! -nargs=1 SystemRg call Ripgrep(<q-args>)

	noremap ]q :call ToggleQuickfix()<CR>
	nnoremap <silent> <leader>cn :cn<CR>
	nnoremap <silent> <leader>cp :cp<CR>

	" vnoremap <silent> <leader>t :term ++open ++rows=9<CR>
	" nnoremap <silent> <leader>t :term ++rows=9<CR>
	" if exists(':tnoremap')
	" 	tnoremap <silent> <leader>t <C-W>:hide<CR>
	" endif

	" [[palette]]执行系统命令并输出到quickfix list			:SystemToQf
	command! -nargs=1 SystemToQf call SystemToQf(<q-args>)
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""

	" Example:
	" :e+22 ~/.vimrc
	command! -nargs=0 VimExeLine exe getline(".")

	if v:version >= 740 || &readonly == 0
		set mouse=a
		if !has('nvim') && has('unix') && exists('$TMUX')
			set ttymouse=xterm2 " Windows termimal 可以用鼠标改变窗口大小
		endif

		set foldmethod=marker
		set foldmarker={,}

		" 默认打开所有折叠，将foldlevelstart设置为较大的值
		"" set foldlevel=-1 " 默认关闭所有折叠
		set foldlevelstart=99
		" https://www.zhihu.com/question/30782510/answer/70078216
		nnoremap zpr :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>:set foldmethod=syntax<CR><CR>
		" 打开所有折叠: zR

		function! CppFoldExpr(lnum)
			let line = getline(a:lnum)
			if !exists('b:cpp_fold_level')
				let b:cpp_fold_level = 0
				let b:last_primitive = ''
			endif

			let open_braces = len(split(line, '{', 1)) - 1
			let close_braces = len(split(line, '}', 1)) - 1
			
			if b:last_primitive == 'if'
				let b:cpp_fold_level += 1
			elseif b:last_primitive == 'end'
				let b:cpp_fold_level -= 1
			endif
			let b:last_primitive = ''
			
			if line =~ '^\s*#\s*\(ifdef\|ifndef\|if\)' || open_braces > close_braces
				let b:cpp_fold_level += 1
				let b:last_primitive = 'if'
				return b:cpp_fold_level
			elseif line =~ '^\s*#\s*\(else\|elif\)' || (open_braces == close_braces && open_braces > 0)
				return b:cpp_fold_level - 1
			elseif line =~ '^\s*#\s*endif' || close_braces > open_braces
				let b:last_primitive = 'end'
				let b:cpp_fold_level -= 1
				return b:cpp_fold_level
			endif

			return b:cpp_fold_level
		endfunction
		autocmd FileType c,cpp setlocal foldmethod=expr foldexpr=CppFoldExpr(v:lnum)
		autocmd FileType python,vim,lua,go,markdown,sh,tex setlocal foldmethod=indent
	endif

	" command -nargs=0 GitBlame !git blame -L line(".") + 1, line(".") + 1 -- %
	" [[palette]]git-blame						:GitBlame
	command -range -nargs=0 GitBlame :!git blame -n -L <line1>,<line2> -- %

	" save
	inoremap <c-S> <esc>:w<CR>i

	if has("autocmd") && exists("+omnifunc")
		autocmd Filetype * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
	endif

	function! MyCppCompleteFunc(findstart, base)
		if a:findstart
			" 确定补全开始的位置
			let line = getline('.')
			let start = col('.') - 1
			while start > 0 && line[start - 1] =~ '\S'
				let start -= 1
			endwhile
			if line[start] != '<' && line[start] != '"'
				return -3
			endif
			return start + 1
		endif

		if getline('.') =~# &include
			let filetype = &filetype
			if filetype == 'cpp' || filetype == 'cuda'
				" r! ls -1 /usr/include/c++/13 | awk '{print " \x27"$0"\x27"}' | paste -sd,
				let completions = ['algorithm', 'any', 'array', 'atomic', 'backward', 'barrier', 'bit', 'bits', 'bitset', 'cassert', 'ccomplex', 'cctype', 'cerrno', 'cfenv', 'cfloat', 'charconv', 'chrono', 'cinttypes', 'ciso646', 'climits', 'clocale', 'cmath', 'codecvt', 'compare', 'complex', 'complex.h', 'concepts', 'condition_variable', 'coroutine', 'csetjmp', 'csignal', 'cstdalign', 'cstdarg', 'cstdbool', 'cstddef', 'cstdint', 'cstdio', 'cstdlib', 'cstring', 'ctgmath', 'ctime', 'cuchar', 'cwchar', 'cwctype', 'cxxabi.h', 'debug', 'decimal', 'deque', 'exception', 'execution', 'expected', 'experimental', 'ext', 'fenv.h', 'filesystem', 'format', 'forward_list', 'fstream', 'functional', 'future', 'initializer_list', 'iomanip', 'ios', 'iosfwd', 'iostream', 'istream', 'iterator', 'latch', 'limits', 'list', 'locale', 'map', 'math.h', 'memory', 'memory_resource', 'mutex', 'new', 'numbers', 'numeric', 'optional', 'ostream', 'parallel', 'pstl', 'queue', 'random', 'ranges', 'ratio', 'regex', 'scoped_allocator', 'semaphore', 'set', 'shared_mutex', 'source_location', 'span', 'spanstream', 'sstream', 'stack', 'stacktrace', 'stdatomic.h', 'stdexcept', 'stdfloat', 'stdlib.h', 'stop_token', 'streambuf', 'string', 'string_view', 'syncstream', 'system_error', 'tgmath.h', 'thread', 'tr1', 'tr2', 'tuple', 'typeindex', 'typeinfo', 'type_traits', 'unordered_map', 'unordered_set', 'utility', 'valarray', 'variant', 'vector', 'version']
				call filter(completions, 'v:val =~ "^" . a:base')
			endif
			" 使用getcompletion()获取文件类型的补全列表
			echom a:base
			let completions += getcompletion(a:base . '*.h*', 'file_in_path', 1)
			let completions += getcompletion(a:base . '*/$', 'file_in_path', 1)
			return completions
		endif
		return []
	endfunction
	autocmd FileType c,cpp,cuda setlocal completefunc=MyCppCompleteFunc
	set laststatus=2

	" file is large from 10mb
	let g:LargeFile = 1024 * 1024 * 10
	function! LargeFile()
		" no syntax highlighting etc
		set eventignore+=FileType
		" save memory when other file is viewed
		setlocal bufhidden=unload
		" is read-only (write with :w new_filename)
		setlocal buftype=nowrite
		" no undo possible
		setlocal undolevels=-1
		" display message
		autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see vimrc for details)."
	endfunction

	augroup LargeFile
		au!
		autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
	augroup END

	let g:tag_system = get(g:, 'tag_system', 'gtags-cscope')
	if has("cscope")
		" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
		set cscopetag
		" 使用quickfix窗口显示搜索结果
		if v:version >= 800
			set cscopequickfix=s-,g-,c-,t-,e-,f-,i-,d-,a-
		else
			set cscopequickfix=s-,g-,c-,t-,e-,f-,i-,d-
		endif

		" show msg when any other cscope db added
		set cscopeverbose
		" 先搜索cscope数据库，如果没有再搜索tags
		set csto=0
		" This tests to see if vim was configured with the '--enable-cscope' option
		" when it was compiled.  If it wasn't, time to recompile vim... 
		
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
		"   'a'   assigned: find places where this symbol is assigned a value

		" <C-R>= ... <CR> 用于计算表达式（如2+2， expand("<cword>")等），并将结果插入到命令行中
		nnoremap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>ce :cs find e <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>cf :cs find f <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>ci :cs find i <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>cd :cs find d <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>ca :cs find a <C-R>=expand("<cword>")<CR><CR>

		" 分裂窗口显示搜索结果
		" nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
		" nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>

		if g:tag_system == 'cscope'
			" Reference: https://cscope.sourceforge.net/cscope_maps.vim
			""""""""""""" Standard cscope/vim boilerplate

			" reset cscope:
			" :cs reset

			" add any cscope database in current directory
			if filereadable("cscope.out")
				cs add cscope.out
			" else add the database pointed to by environment variable
			elseif $CSCOPE_DB != ""
				cs add $CSCOPE_DB
			endif

		elseif g:tag_system == 'gtags-cscope'
			set csprg=gtags-cscope
			if filereadable('GTAGS')
				cs add GTAGS
			endif
		endif
	endif

	if filereadable(expand("~/config_single_vimrc.vim"))
		source $HOME/config_single_vimrc.vim
	endif
endif