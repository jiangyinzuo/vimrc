function! largefile#LargeFile()
	" no syntax highlighting etc
	set eventignore+=FileType
	" save memory when other file is viewed
	setlocal bufhidden=unload
	" is read-only (write with :w new_filename)
	setlocal buftype=nowrite
	" no undo possible
	setlocal undolevels=-1
	" display message
	autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see vimrc for details)."
endfunction

