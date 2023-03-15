Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

"文件搜索
nnoremap <silent> <leader>ff :Leaderf file --auto-preview<CR>

"历史打开过的文件
nnoremap <silent> <leader>fh :Leaderf mru --auto-preview<CR>

"Buffer
nnoremap <silent> <leader>b :Leaderf buffer --nameOnly --auto-preview<CR>
nnoremap <silent> <leader>sb :10sp<CR>:Leaderf buffer --nameOnly --auto-preview<CR>
tnoremap <silent> <leader>b <C-W>:Leaderf buffer --nameOnly --auto-preview<CR>

"Based on ripgrep
nnoremap <silent> <Leader>rg :Leaderf rg --nameOnly --auto-preview<CR>

if v:version >= 802
	let g:Lf_WindowPosition = 'popup'
  let g:Lf_PreviewInPopup = 1
  let g:Lf_PopupWidth = 0
  let g:Lf_PopupHeight = 0.7
	let g:Lf_PopupPreviewPosition = 'right'
endif

let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_RootMarkers = ['.git', '.root']
let g:Lf_ShowDevIcons = 0
let g:Lf_DisableStl = 0
let g:Lf_RgConfig = ["--glob=!deps/* --glob=!build/* --glob=!*.html"]

" 查找时忽略以下目录和文件
let g:Lf_WildIgnore = {
  \ 'dir': ['.git', '__pycache__', '.DS_Store', '.svn', '.cache', 'deps', 'build'],
  \ 'file': ['*.exe', '*.dll', '*.so', '*.o', '*.pyc', '*.jpg', '*.png',
  \ '*.gif', '*.svg', '*.ico', '*.db', '*.tgz', '*.tar.gz', '*.gz',
  \ '*.zip', '*.bin', '*.pptx', '*.xlsx', '*.docx', '*.pdf', '*.tmp',
  \ '*.wmv', '*.mkv', '*.mp4', '*.rmvb', '*.ttf', '*.ttc', '*.otf',
  \ '*.mp3', '*.aac', '*.orig', '*.min.*', '*.html']
  \}

