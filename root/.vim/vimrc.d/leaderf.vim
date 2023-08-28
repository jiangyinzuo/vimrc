" Alternative plugin: vim-clap
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
" let g:Lf_WindowHeight = 0.9
" let g:Lf_PopupWidth = 0.9
"let g:Lf_PreviewPopupWidth = &columns * 5 / 10
"let g:Lf_PopupHeight = 0.8
let g:Lf_PopupPreviewPosition = 'top'
" let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
" let g:Lf_PopupPosition = [1, 1]

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
" 打开quickfix list（可以和gtags配合使用）
nnoremap <silent> <leader>fq :Leaderf quickfix <CR>

nnoremap <silent> <leader>fb :Leaderf buffer --nameOnly <CR>
tnoremap <silent> <leader>fb :Leaderf buffer --nameOnly <CR>
"Buffer
nnoremap <silent> <leader>fsb :10sp<CR>:Leaderf buffer --nameOnly <CR>

"Based on ripgrep
nnoremap <silent> <Leader>rg :Leaderf rg --fuzzy  <CR>
" search visually selected text literally

" #gpt4-answer
" :<C-U>：清除命令行中的任何现有内容。
"
" `<C-R>=` 在 Vim 中是用来插入表达式寄存器的内容的。表达式寄存器可以包含 Vimscript 表达式，并且可以在你需要插入文本的任何地方使用。当你输入 `<C-R>=` 后，Vim 将进入表达式寄存器模式，你可以在这个模式中输入任何有效的 Vimscript 表达式。当你按下 `<Enter>` 之后，Vim 会计算你输入的表达式，并插入计算的结果。
" 
" 以下是一些 `<C-R>=` 的例子：
" - 在插入模式下，你可以按 `<C-R>=2+2<Enter>` 来插入 "4"。
" - 在命令行模式下，你可以输入 `:echo <C-R>=2+2<Enter>` 来打印 "4"。
" - 在你的 `.vimrc` 文件中，你可以使用 `<C-R>=` 创建一个映射，这个映射可以插入当前的日期和时间。例如：
" 
"   ```vim
"   inoremap <F5> <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>
"   ```
"   这个映射将 `<F5>` 键映射到一个 Vimscript 表达式，这个表达式使用 `strftime` 函数生成当前的日期和时间。当你在插入模式下按 `<F5>` 时，Vim 就会插入这个日期和时间。
" 
" 这些例子应该可以帮助你理解 `<C-R>=` 的作用和用法。记住，你可以使用任何有效的 Vimscript 表达式，包括函数调用、变量、算术和字符串操作等等。
xnoremap <silent> <leader>rg :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>

let g:Lf_WorkingDirectoryMode = 'a'
let g:Lf_RootMarkers = g:RootMarks
let g:Lf_ShowDevIcons = 0
let g:Lf_DisableStl = 0
let g:Lf_RgConfig = ["--glob=!deps/* --glob=!build/* --glob=!*.html --glob=!tags"]
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_GtagsAutoGenerate = 0

" 查找时忽略以下目录和文件
let g:Lf_WildIgnore = {
  \ 'dir': ['.git', '__pycache__', '.DS_Store', '.svn', '.cache', 'deps', 'build'],
  \ 'file': ['tags', 'GTAGS', 'GRTAGS', 'GPATH', '*.exe', '*.dll', '*.so', '*.o', '*.pyc', '*.jpg', '*.png', '*.webp',
  \ '*.gif', '*.svg', '*.ico', '*.db', '*.tgz', '*.tar.gz', '*.gz',
  \ '*.zip', '*.bin', '*.ppt', '*.pptx', '*.xls', '*.xlsx', '*.doc', '*.docx', '*.pdf', '*.tmp',
  \ '*.wmv', '*.mkv', '*.mp4', '*.rmvb', '*.ttf', '*.ttc', '*.otf',
  \ '*.mp3', '*.aac', '*.orig', '*.min.*', '*.html', '*.htm', '**/tags']
  \}

