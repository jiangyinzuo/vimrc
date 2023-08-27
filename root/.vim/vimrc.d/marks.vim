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

" A-Z mark目前不支持在初始化阶段添加sign
sign define markA text='A texthl=Todo
sign define markB text='B texthl=Todo
sign define markC text='C texthl=Todo
sign define markD text='D texthl=Todo
sign define markE text='E texthl=Todo
sign define markF text='F texthl=Todo
sign define markG text='G texthl=Todo
sign define markH text='H texthl=Todo
sign define markI text='I texthl=Todo
sign define markJ text='J texthl=Todo
sign define markK text='K texthl=Todo
sign define markL text='L texthl=Todo
sign define markM text='M texthl=Todo
sign define markN text='N texthl=Todo
sign define markO text='O texthl=Todo
sign define markP text='P texthl=Todo
sign define markQ text='Q texthl=Todo
sign define markR text='R texthl=Todo
sign define markS text='S texthl=Todo
sign define markT text='T texthl=Todo
sign define markU text='U texthl=Todo
sign define markV text='V texthl=Todo
sign define markW text='W texthl=Todo
sign define markX text='X texthl=Todo
sign define markY text='Y texthl=Todo
sign define markZ text='Z texthl=Todo

function SignMark(mark)
  call sign_unplace(a:mark, {'buffer': bufnr()})
  call sign_place(0, a:mark, a:mark, bufnr(), {'lnum': line('.'), 'priority': 20})
endfunction

" 为小写字母 a 到 z 创建映射
for mark in range(char2nr('a'), char2nr('z'))
  let sign_name = 'mark' . nr2char(mark)
  execute 'nnoremap m' . nr2char(mark) . ' m' . nr2char(mark) . ':call SignMark("' . sign_name . '")<CR>'
endfor

" 为大写字母 A 到 Z 创建映射
for mark in range(char2nr('A'), char2nr('Z'))
  let sign_name = 'mark' . nr2char(mark)
  execute 'nnoremap m' . nr2char(mark) . ' m' . nr2char(mark) . ':call SignMark("' . sign_name . '")<CR>'
endfor
