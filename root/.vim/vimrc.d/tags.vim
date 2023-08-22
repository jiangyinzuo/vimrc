if v:version >= 801
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'skywind3000/gutentags_plus'

  let $GTAGSLABEL = 'native-pygments'
  " 当前使用.globalrc配置文件
  " let $GTAGSCONF = '/root/gtags.conf'

  let g:gutentags_enabled = 0
  " enable gtags module
  let g:gutentags_modules = ['ctags', 'gtags_cscope']
  
  " config project root markers.
  let g:gutentags_project_root = ['.root', '.git', '.svn']
  
  " generate datebases in my cache directory, prevent gtags files polluting my project
  " let g:gutentags_cache_dir = expand('~/.cache/tags')
  
  " change focus to quickfix window after search (optional).
  let g:gutentags_plus_switch = 1

  " 配置 ctags 的参数，老的 Exuberant-ctags 不能有 --extra=+q，注意
  " 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
  " let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

  " 禁用 gutentags 自动加载 gtags 数据库的行为
  let g:gutentags_auto_add_gtags_cscope = 0
endif
