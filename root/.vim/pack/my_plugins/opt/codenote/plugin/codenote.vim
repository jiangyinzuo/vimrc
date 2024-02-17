" colon 表示使用 path/to/filename.ext:line_number 格式
" plus 表示使用 +line_number path/to/filename.ext 格式
let g:codenote_filepath_style = "colon"

" [[palette]]打开NoteRepo						:OpenNoteRepo
command -nargs=0 OpenNoteRepo :call codenote#OpenNoteRepo()

" [[palette]]打开CodeRepo						:OpenCodeRepo
command -nargs=0 OpenCodeRepo :call codenote#OpenCodeRepo()
command -nargs=0 RefreshCodeLinks :call codenote#GetAllCodeLinks()

" need_beginline, need_endline, append, goto_buf
nnoremap <silent> <leader>nr :call codenote#YankCodeLink(0, 0, 0, 1)<CR>
nnoremap <silent> <leader>ny :call codenote#YankCodeLink(1, 1, 0, 1)<CR>
nnoremap <silent> <leader>nb :call codenote#YankCodeLink(1, 0, 0, 0)<CR>
nnoremap <silent> <leader>na :call codenote#YankCodeLink(0, 0, 1, 0)<CR>
nnoremap <silent> <leader>ne :call codenote#YankCodeLink(0, 1, 1, 1)<CR>
nnoremap <silent> <leader>nf :call codenote#YankCodeWithFunctionHeader('[f')<CR>
nnoremap <silent> <leader>nm :call codenote#YankCodeWithFunctionHeader('[m')<CR>


vnoremap <silent> <leader>nf :call codenote#YankCodeWithFunctionHeaderVisual('[f')<CR>
vnoremap <silent> <leader>nm :call codenote#YankCodeWithFunctionHeaderVisual('[m')<CR>
vnoremap <silent> <leader>nr :call codenote#YankCodeLinkVisual(0, 0, 0, 1)<CR>
vnoremap <silent> <leader>ny :call codenote#YankCodeLinkVisual(1, 1, 0, 1)<CR>
vnoremap <silent> <leader>nb :call codenote#YankCodeLinkVisual(1, 0, 0, 0)<CR>
vnoremap <silent> <leader>na :call codenote#YankCodeLinkVisual(0, 0, 1, 0)<CR>
vnoremap <silent> <leader>ne :call codenote#YankCodeLinkVisual(0, 1, 1, 1)<CR>

" 1) goto code/note link
" 2) put the cursor to center of screen
nnoremap <silent> <leader><C-]> :call codenote#GoToCodeNoteLink()<CR>z.

