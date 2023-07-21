"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""                                     TAGS                                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 递归向上层寻找tags文件
" set tags=tags;/

" Reference: https://cscope.sourceforge.net/cscope_maps.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:tags_use_cscope = 1
let s:tags_use_gtags = 1

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
		source ~/.vim/vimrc.d/gtags-cscope.vim " https://www.gnu.org/software/global/globaldoc_toc.html#Gtags_002dcscope
	endif
elseif s:tags_use_gtags && s:has_vimrcd
	source ~/.vim/vimrc.d/gtags.vim " https://www.gnu.org/software/global/globaldoc_toc.html#Vim-editor
	nnoremap <C-]> :Gtags -d <C-R>=expand("<cword>")<CR><CR>
endif
