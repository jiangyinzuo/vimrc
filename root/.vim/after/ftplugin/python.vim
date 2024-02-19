command! -nargs=0 JupyterExecute :call jupyter_ascending#execute()
command! -nargs=0 JupyterExecuteAll :call jupyter_ascending#execute_all()
command! -nargs=0 JupyterRestart :call jupyter_ascending#restart()
command! -nargs=0 JupyterOpenPairNotebook :call jupyter#JupyterOpenNotebook()
