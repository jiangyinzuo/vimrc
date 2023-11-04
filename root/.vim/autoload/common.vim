" https://www.zhihu.com/question/26248191/answer/2680677733
function! common#GoToFile(file,lineNum)
  let bufName = bufname(a:file)
  if bufName == ""
    execute 'edit +'.a:lineNum a:file
  else
    let bufNum = bufnr(bufName)
    execut 'b '.bufNum
    call feedkeys(a:lineNum."G","n")
  endif

  if foldclosed('.') != -1
   call feedkeys("zo","n")
  end

  call feedkeys("zz","n")
endfunction

