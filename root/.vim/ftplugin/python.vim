" 先运行JupyterConsole, 再运行:JupyterConnect
command! -nargs=0 JupyterConsole :AsyncRun -mode=term -pos=right -focus=0 jupyter console
let b:slime_cell_delimiter = '##'
let b:slime_vimterminal_cmd = 'ipython3'

command! -nargs=0 MatplotlibQtInline :JupyterSendCode "import matplotlib\nmatplotlib.use('QtAgg')\n%matplotlib inline\n%load_ext autoreload\n%autoreload 2\n"
