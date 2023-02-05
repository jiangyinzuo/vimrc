Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
""""""""""""""""""""""""""""""
"Leaderf settings
""""""""""""""""""""""""""""""
"文件搜索
nnoremap <silent> <leader>f :Leaderf file<CR>

"历史打开过的文件
nnoremap <silent> <leader>h :Leaderf mru<CR>

"Buffer
nnoremap <silent> <leader>b :Leaderf buffer<CR>

"Based on ripgrep
nnoremap <silent> <Leader>rg :Leaderf rg --nameOnly<CR>

let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_RootMarkers = ['.git', '.root']
let g:Lf_ShowDevIcons = 0
let g:Lf_RgConfig = ["--glob=!deps/* --glob=!build/*"]
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn', '.git', '.cache', 'deps', 'build'],
    \ 'file': []
    \}
""""""""""""""""""""""""""""""
