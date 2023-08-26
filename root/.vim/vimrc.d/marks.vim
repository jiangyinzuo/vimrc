" 目前仅支持a-z的marks添加sign
sign define marka text='a texthl=Todo
sign define markb text='b texthl=Todo
sign define markc text='c texthl=Todo
sign define markd text='d texthl=Todo
sign define marke text='e texthl=Todo
sign define markf text='f texthl=Todo
sign define markg text='g texthl=Todo
sign define markh text='h texthl=Todo
sign define marki text='i texthl=Todo
sign define markj text='j texthl=Todo
sign define markk text='k texthl=Todo
sign define markl text='l texthl=Todo
sign define markm text='m texthl=Todo
sign define markn text='n texthl=Todo
sign define marko text='o texthl=Todo
sign define markp text='p texthl=Todo
sign define markq text='q texthl=Todo
sign define markr text='r texthl=Todo
sign define marks text='s texthl=Todo
sign define markt text='t texthl=Todo
sign define marku text='u texthl=Todo
sign define markv text='v texthl=Todo
sign define markw text='w texthl=Todo
sign define markx text='x texthl=Todo
sign define marky text='y texthl=Todo
sign define markz text='z texthl=Todo

function SignMark(mark)
  call sign_unplace(a:mark, {'buffer': bufnr()})
  call sign_place(0, a:mark, a:mark, bufnr(), {'lnum': line('.'), 'priority': 20})
endfunction

" 为小写字母 a 到 z 创建映射
for mark in range(char2nr('a'), char2nr('z'))
  let sign_name = 'mark' . nr2char(mark)
  execute 'nnoremap m' . nr2char(mark) . ' m' . nr2char(mark) . ':call SignMark("' . sign_name . '")<CR>'
endfor

