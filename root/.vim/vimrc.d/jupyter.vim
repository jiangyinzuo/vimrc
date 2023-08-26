let g:jupyter_ascending_default_mappings = 0

" See: https://github.com/untitled-ai/jupyter_ascending.vim
Plug 'untitled-ai/jupyter_ascending.vim'

command -nargs=0 JupyterExecute :call jupyter_ascending#execute()
command -nargs=0 JupyterExecuteAll :call jupyter_ascending#execute_all()
command -nargs=0 JupyterRestart :call jupyter_ascending#restart()

" # Use # %% to separate cells. Use # %% [markdown] to make a markdown block.
function JupyterCreateNotebook()
	let name = input('Notebook name: ')
	let name = trim(name)
	if name != ''
		execute 'e ' . name . '.sync.ipynb'
		execute 'AsyncRun -pos=tab -mode=term -name=JupyterCreateNotebook -cwd=' . getcwd() . ' python -m jupyter_ascending.scripts.make_pair --base ' . name . '&& jupyter notebook ' . name .'.sync.ipynb --allow-root'
	endif
endfunction

command -nargs=0 JupyterCreatePairNotebook :call JupyterCreateNotebook()

