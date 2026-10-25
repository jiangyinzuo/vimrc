" 保留源码首行的缩进，不使用默认 foldtext() 去掉前导空白。
function! s:PythonFoldText() abort
  return getline(v:foldstart) . '  [' . (v:foldend - v:foldstart + 1) . ' lines]'
endfunction

let &l:foldtext = expand('<SID>') . 'PythonFoldText()'
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '') . '|setlocal foldtext<'

" Neovim 按语法节点折叠；Vim 继续沿用原来的 indent 折叠。
if has('nvim')
  setlocal foldmethod=expr
  setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
  let b:undo_ftplugin .= '|setlocal foldmethod< foldexpr<'
endif
