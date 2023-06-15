Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

let g:asyncrun_open = 6 " open quickfix window automatically at 6 lines height after command starts
let g:asyncrun_rootmarks = ['.git', '.root']
let g:asynctasks_term_pos = 'tab'
let g:asynctasks_term_reuse = 1

" 复制pathline用于gF文件跳转
" See rffv() in fzf/fzf.bash
command! -nargs=0 YankPathLine let @" = expand('%:p')[len(asyncrun#get_root('%')) + 1:] . ':' . line(".")

command! -nargs=0 Cdroot let project_root = asyncrun#get_root('%') | exe 'cd ' . project_root | pwd
