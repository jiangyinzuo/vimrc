augroup jump_to_symbol
	autocmd!
	" See: https://stackoverflow.com/questions/12128678/vim-go-to-beginning-end-of-next-method
	" 在这里，我们用 \< 和 \> 来指定词的边界，这样我们就可以准确地匹配func，而不是 func 作为其他词的一部分。bW 和 wW是搜索命令的标志，b 表示向后搜索，w 表示向前搜索，W 表示只匹配整个单词。
	" 以上代码仅会简单地跳转到包含 func 关键字的行，不过如果你需要更精确或更高级的功能，你可能需要考虑使用一些专门为
	" Go 语言设计的 Vim 插件，例如 vim-go。这个插件为 Go语言提供了许多功能，包括代码导航、自动完成、代码格式化等等。
	autocmd FileType lua nnoremap <silent> <buffer> [f :call search('\<function\>', "bW")<CR>
	autocmd FileType lua nnoremap <silent> <buffer> ]f :call search('\<function\>', "wW")<CR>
augroup END

" https://github.com/tpope/vim-unimpaired
nnoremap <silent> ]Q :clast<CR>
nnoremap <silent> [Q :crewind<CR>
nnoremap <silent> ]q :cn<CR>
nnoremap <silent> [q :cp<CR>
nnoremap <silent> ]l :ln<CR>
nnoremap <silent> [l :lp<CR>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [a :previous<CR>
nnoremap <silent> ]a :next<CR>

" .txt的helpfile，第一行必须都是英文，不能包含中文，否则报 mixed encoding的错误
" set helplang=cn
helptags ~/.vim/doc
helptags ~/.vim/pack/my_plugins/start/project.vim/doc
helptags ~/.vim/pack/my_plugins/start/duckdb.vim/doc

if exists('&viminfofile')
	set viminfofile=$HOME/.vim/.viminfo
	" 保留50个marks
	" 每个寄存器保存50行内容
	" 保存50行搜索历史
	" 保存50行命令历史
	" 禁止hlsearch
	" 禁止保存超过10kb的寄存器内容
	" 保存0-9，A-Zmark
	set viminfo='50,<50,/50,:50,h,s10,f100
	set termencoding=utf-8
endif

""""""""""""""""" StatusLine """"""""""""""""""
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
" See: https://zhuanlan.zhihu.com/p/532430825
set laststatus=2
set statusline=%1*%F%m%r%h%w
let show_status = exists("g:plugs") && v:version >= 900 && g:no_vimplug == 0
if show_status
	set statusline+=%{statusline#Left()}
endif
" 左对齐和右对齐的分割点
set statusline+=%=
if show_status
	if show_status && g:ai_suggestion == 'codeium'
		set statusline+=%2*%{winwidth(0)>60?codeium#GetStatusString():''}\ %{%statusline#Right()%}
	else
		set statusline+=%2*%{%statusline#Right()%}
	endif
else
	set statusline+=%l/%L:%v\ %Y\ %{&fenc}\ %{&ff}
endif

""""""""""""""""""" Tag System """""""""""""""""
" gtags-cscope | cscope
let g:tag_system = get(g:, 'tag_system', 'gtags-cscope')
" 当前使用.globalrc配置文件
" let $GTAGSCONF = '/root/gtags.conf'

" 不使用 ludovicchabant/vim-gutentags 插件的原因:
" 该插件会设置$GTAGSROOT 和 $GTAGSDBPATH 环境变量，导致gtags不能按预期工作

" 递归向上层寻找tags文件
" set tags=tags;/
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
	""""""""""""" My cscope/vim key mappings
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
		if filereadable("cscope.out")
			" add any cscope database in current directory
			cs add cscope.out
		elseif $CSCOPE_DB != ""
			" else add the database pointed to by environment variable
			cs add $CSCOPE_DB
		endif
	elseif g:tag_system == 'gtags-cscope'
		set csprg=gtags-cscope
	endif
endif
