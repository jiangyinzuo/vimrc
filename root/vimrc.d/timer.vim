let g:timers = {}

function s:timerAutoSave(timer)
	if &readonly == 0 && &modified == 1
		silent write
	  " echo 'auto saved at ' . strftime('%X')
	endif
endfunction

function TimerStartAutoSave()
	if !has_key(g:timers, 'auto_save')
		let g:timers.auto_save = timer_start(30000, 's:timerAutoSave', {'repeat': -1})
	endif
endfunction

function TimerStopAutoSave()
	if has_key(g:timers, 'auto_save')
		let timer = g:timers['auto_save']
		call timer_stop(timer)
		unlet g:timers['auto_save']
	endif
endfunction
