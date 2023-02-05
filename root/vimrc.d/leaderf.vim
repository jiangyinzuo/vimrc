Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
""""""""""""""""""""""""""""""
"Leaderf settings
""""""""""""""""""""""""""""""
"文件搜索
nnoremap <silent> <leader>f :Leaderf file<CR>

"历史打开过的文件
nnoremap <silent> <leader>h :Leaderf mru<CR>

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
let g:Lf_RgConfig = ["--glob=!deps/* --glob=!build/*"]
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn', '.git', '.cache', 'deps', 'build'],
    \ 'file': []
    \}
""""""""""""""""""""""""""""""
