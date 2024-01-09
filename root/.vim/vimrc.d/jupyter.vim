let g:jupyter_ascending_default_mappings = 0

" See: https://github.com/untitled-ai/jupyter_ascending.vim
Plug 'untitled-ai/jupyter_ascending.vim'

command -nargs=0 JupyterExecute :call jupyter_ascending#execute()
command -nargs=0 JupyterExecuteAll :call jupyter_ascending#execute_all()
command -nargs=0 JupyterRestart :call jupyter_ascending#restart()

command -nargs=0 JupyterOpenPairNotebook :call jupyter#JupyterOpenNotebook()

let g:jupyter_ascending_python_executable = 'python3'

" 同步到浏览器内存中，若要同步到.ipynb文件中，需要浏览器手动/自动定时保存
let g:jupyter_ascending_auto_write = v:true
