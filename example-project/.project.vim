let t:header_guard_prefix = '_PROJECT_'
let t:header_guard_suffix = '_'
let t:autoload_codenote = 0
let t:autocd_project_root = 0

let g:Lf_WildIgnore['dir']->extend(['contrib'])

" 自动保存/加载折叠
autocmd BufWinLeave *.go mkview
autocmd BufWinEnter *.go silent loadview
