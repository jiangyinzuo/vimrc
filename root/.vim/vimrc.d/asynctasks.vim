Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

let g:asyncrun_open = 6 " open quickfix window automatically at 6 lines height after command starts
let g:asyncrun_rootmarks = g:RootMarks
let g:asynctasks_term_pos = 'tab'
let g:asynctasks_term_reuse = 1

command! -nargs=0 Cdroot let project_root = asyncrun#get_root('%') | exe 'cd ' . project_root | pwd

function AsyncRunOrSystem(cmd)
	if g:asyncrun_support == 1
		call asyncrun#run('', {'silent': 1}, a:cmd)
	else
		call system(a:cmd)
	endif
endfunction
