let g:asyncrun_open = 4 " open quickfix window automatically at 4 lines height after command starts
let g:asyncrun_rootmarks = g:RootMarks
let g:asynctasks_term_pos = 'tab'
let g:asynctasks_term_reuse = 1
let g:asynctasks_term_rows = 4
let g:asynctasks_term_focus = 1

command -nargs=0 Cdroot let project_root = asyncrun#current_root() | exe 'cd ' . project_root | pwd
command -nargs=0 Lcdroot let project_root = asyncrun#current_root() | exe 'lcd ' . project_root | pwd
command -nargs=0 Tcdroot let project_root = asyncrun#current_root() | exe 'tcd ' . project_root | pwd
command -nargs=0 CdrootCfile let project_root = asyncrun#get_root('%:p:h') | exe 'cd ' . project_root | pwd
command -nargs=0 LcdrootCfile let project_root = asyncrun#get_root('%:p:h') | exe 'lcd ' . project_root | pwd
command -nargs=0 TcdrootCfile let project_root = asyncrun#get_root('%:p:h') | exe 'tcd ' . project_root | pwd

command -nargs=* -complete=customlist,asynctasks_custom#MakefileComplete Make AsyncTask make +make_target=<args>
command -bang -nargs=* -complete=file MakeInternalCmd AsyncRun -program=make @ <args>

command -nargs=? OpenCFile call asynctasks_custom#Open(<q-args>)

command -range=% -nargs=* AsyncRunSelected call asynctasks_custom#RunSelected(<q-args>)
