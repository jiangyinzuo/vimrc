if v:version >= 801
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'skywind3000/gutentags_plus'
  
  let g:gutentags_enabled = 0
  " enable gtags module
  let g:gutentags_modules = ['ctags', 'gtags_cscope']
  
  " config project root markers.
  let g:gutentags_project_root = ['.root', '.git', '.svn']
  
  " generate datebases in my cache directory, prevent gtags files polluting my project
  " let g:gutentags_cache_dir = expand('~/.cache/tags')
  
  " change focus to quickfix window after search (optional).
  let g:gutentags_plus_switch = 1
endif
