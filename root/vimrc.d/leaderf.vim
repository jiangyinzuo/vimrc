Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

"文件搜索
let g:Lf_ShortcutF = '<leader>ff'

function Leaderf_current_dir()
	let l:c = expand("%:h")
	exe "Leaderf file " . l:c
endfunction
" 当前文件所在目录下搜索文件
nnoremap <silent> <leader>fc :call Leaderf_current_dir()<CR>

"历史打开过的文件
nnoremap <silent> <leader>fh :Leaderf mru <CR>

"Buffer
nnoremap <silent> <leader>b :Leaderf buffer --nameOnly <CR>
nnoremap <silent> <leader>sb :10sp<CR>:Leaderf buffer --nameOnly <CR>
tnoremap <silent> <leader>b <C-W>:Leaderf buffer --nameOnly <CR>

"Based on ripgrep
nnoremap <silent> <Leader>rg :Leaderf rg --fuzzy <CR>

let g:Lf_WorkingDirectoryMode = 'a'
let g:Lf_RootMarkers = g:RootMarks
let g:Lf_ShowDevIcons = 0
let g:Lf_DisableStl = 0
let g:Lf_RgConfig = ["--glob=!deps/* --glob=!build/* --glob=!*.html"]
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_GtagsAutoGenerate = 0

" 查找时忽略以下目录和文件
let g:Lf_WildIgnore = {
  \ 'dir': ['.git', '__pycache__', '.DS_Store', '.svn', '.cache', 'deps', 'build'],
  \ 'file': ['*.exe', '*.dll', '*.so', '*.o', '*.pyc', '*.jpg', '*.png', '*.webp',
  \ '*.gif', '*.svg', '*.ico', '*.db', '*.tgz', '*.tar.gz', '*.gz',
  \ '*.zip', '*.bin', '*.ppt', '*.pptx', '*.xls', '*.xlsx', '*.doc', '*.docx', '*.pdf', '*.tmp',
  \ '*.wmv', '*.mkv', '*.mp4', '*.rmvb', '*.ttf', '*.ttc', '*.otf',
  \ '*.mp3', '*.aac', '*.orig', '*.min.*', '*.html', '*.htm']
  \}

