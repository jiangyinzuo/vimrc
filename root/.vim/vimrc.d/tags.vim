" 当前使用.globalrc配置文件
" let $GTAGSCONF = '/root/gtags.conf'

" 不使用 ludovicchabant/vim-gutentags 插件的原因:
" 该插件会设置$GTAGSROOT 和 $GTAGSDBPATH 环境变量，导致gtags不能按预期工作

" 递归向上层寻找tags文件
" set tags=tags;/

" gtags-cscope | gtags | cscope
let s:tags = 'gtags-cscope'

if has("cscope")
	" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
	set cscopetag
	" 使用quickfix窗口显示搜索结果
	set cscopequickfix=s-,g-,c-,t-,e-,f-,i-,d-,a-
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

	if s:tags == 'cscope'
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

	elseif s:tags == 'gtags-cscope'
    set csprg=gtags-cscope
		function s:gtags_cscope_add()
			let l:project_root = asyncrun#current_root()
			if l:project_root != $HOME && l:project_root != ''
				let l:gtags_db = l:project_root . '/GTAGS'
				if filereadable(l:gtags_db) && cscope_connection(2, l:gtags_db) == 0
					execute 'cs add ' . l:gtags_db
				endif
			endif
		endfunction
		function s:update_gtags()
			let l:project_root = asyncrun#current_root()
			if l:project_root != $HOME && l:project_root != ''
				let l:gtags_db = l:project_root . '/GTAGS'
				if filereadable(l:gtags_db)
					execute 'lcd ' . l:project_root
					" 保存当前工作目录
					let l:cwd = getcwd()
					" 增量更新gtags db
					silent! !global -u
					" 恢复当前工作目录
					execute 'lcd ' . l:cwd
				endif
			endif
		endfunction
		augroup GlobalCscope
			autocmd!
			" 自动加载gtags db
			autocmd VimEnter * call s:gtags_cscope_add()
			autocmd BufWritePost * call s:update_gtags()
		augroup END
		" 不使用global官方gtags-cscope vimscript
		" https://www.gnu.org/software/global/globaldoc_toc.html#Gtags_002dcscope
		" source ~/.vim/vimrc.d/gtags-cscope.vim
	endif
elseif s:tags == 'gtags'
	source ~/.vim/vimrc.d/gtags.vim " https://www.gnu.org/software/global/globaldoc_toc.html#Vim-editor
	nnoremap <C-]> :Gtags -d <C-R>=expand("<cword>")<CR><CR>
endif
