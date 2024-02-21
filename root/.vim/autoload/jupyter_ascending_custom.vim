vim9script
# Use # %% to separate cells. Use # %% [markdown] to make a markdown block.
export def JupyterOpenNotebook()
	var name = ''
	if expand('%') =~# '\.sync\.py$'
		# This is a sync file, open the corresponding notebook
		name = expand('%:r:r')
	else
		name = input('Notebook name: ')
		name = trim(name)
	endif

	if name != ''
		execute 'e ' .. name .. '.sync.py'
		execute 'AsyncRun -pos=tab -mode=term -name=JupyterCreateNotebook -cwd=' .. getcwd() ..
			' jupyter_ascending.sh ' .. name
	endif
enddef

