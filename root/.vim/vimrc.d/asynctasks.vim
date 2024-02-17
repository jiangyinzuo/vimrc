Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

let g:asyncrun_open = 4 " open quickfix window automatically at 4 lines height after command starts
let g:asyncrun_rootmarks = g:RootMarks
let g:asynctasks_term_pos = 'tab'
let g:asynctasks_term_reuse = 1
let g:asynctasks_term_rows = 4
let g:asynctasks_term_focus = 1

command! -nargs=0 Cdroot let project_root = asyncrun#current_root() | exe 'cd ' . project_root | pwd
command! -nargs=0 Tcdroot let project_root = asyncrun#current_root() | exe 'tcd ' . project_root | pwd
command! -nargs=0 CdrootSourceProject let project_root = asyncrun#get_root('%:p:h') | exe 'cd ' . project_root | exe 'source ' . g:project_vimrc | pwd
command! -nargs=0 TcdrootSourceProject let project_root = asyncrun#get_root('%:p:h') | exe 'tcd ' . project_root | exe 'source ' . g:project_vimrc | pwd

function AsyncRunOrSystem(cmd)
	if g:asyncrun_support == 1
		call asyncrun#run('', {'silent': 1}, a:cmd)
	else
		call system(a:cmd)
	endif
endfunction

command -nargs=0 BuildFileDebug :AsyncTask file-build-debug
command -nargs=0 RunFile        :AsyncTask file-run
command -nargs=* -complete=customlist,asynctasks_custom#MakefileComplete Make :AsyncTask make +make_target=<args>
