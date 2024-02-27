command! -nargs=0 JupyterAscendingExecute :call jupyter_ascending#execute()
command! -nargs=0 JupyterAscendingExecuteAll :call jupyter_ascending#execute_all()
command! -nargs=0 JupyterAscendingRestart :call jupyter_ascending#restart()
command! -nargs=0 JupyterAscendingOpenPairNotebook :call jupyter_ascending_custom#JupyterOpenNotebook()

" 先运行JupyterConsole, 再运行:JupyterConnect
command! -nargs=0 JupyterConsole :AsyncRun -mode=term -pos=right -focus=0 jupyter console
let b:slime_cell_delimiter = '##'
let b:slime_vimterminal_cmd = 'ipython3'

command! -nargs=0 MatplotlibQtInline :JupyterSendCode "import matplotlib\nmatplotlib.use('QtAgg')\n%matplotlib inline\n%load_ext autoreload\n%autoreload 2\n"
