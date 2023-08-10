let g:term_loc_variable = '$LOC'

highlight TermDebuggerBreakpoint ctermfg=red guifg=red
highlight TermDebuggercursor ctermfg=green guifg=green
sign define TermDebuggerCursor text==> linehl=CursorLine texthl=TermDebuggerCursor
sign define TermDebuggerBreakpoint text=● texthl=TermDebuggerBreakpoint

function s:placeBreakpoint(filename, line)
	call bufadd(a:filename)
	let l:bnr = bufnr(a:filename)
	call sign_place(a:line, 'TermDebuggerBreakpoint', 'TermDebuggerBreakpoint',
				\	l:bnr, {'lnum': a:line, 'priority': 90})
endfunction

function Tapi_TermDebuggerStepTo(bufnum, arglist)
	let l:filename = a:arglist[0]
	let l:line = a:arglist[1]

	if filereadable(l:filename)
		let l:key = t:cursor_filename . ':' . t:cursor_line
		if has_key(t:breakpoints, l:key)
			call s:placeBreakpoint(t:cursor_filename, t:cursor_line)
		else
			call sign_unplace('TermDebuggerCursor')
		endif
		2wincmd w
		exe 'edit +' . l:line . ' ' . l:filename
		let l:bufnr = winbufnr(2)
		z.
		call sign_place(0, 'TermDebuggerCursor', 'TermDebuggerCursor', l:bufnr, {'lnum': l:line, 'priority': 90})
		let t:cursor_filename = l:filename
		let t:cursor_line = l:line
		1wincmd w
	else
		echom "file not found: " . l:filename
	endif
endfunction

function Tapi_TermDebuggerSignBreakpoint(bufnum, arglist)
	let l:brk_type = a:arglist[0]
	let l:filename = a:arglist[1]
	let l:line = a:arglist[2]

	let l:key = l:filename . ':' . l:line
	let t:breakpoints[l:key] = l:brk_type
	if l:filename != t:cursor_filename || l:line != t:cursor_line
		call s:placeBreakpoint(l:filename, l:line)
	endif
endfunction

function term_debugger#term_exit_cb(job, exit_status)
	call sign_unplace('TermDebuggerCursor')
	call sign_unplace('TermDebuggerBreakpoint')
endfunction

function term_debugger#open_terminal(command)
	" filename:line -> brk_type
	let t:breakpoints = {}
	let t:cursor_filename = ""
	let t:cursor_line = 0
	let t:term_bufnr = term_start(a:command, {'exit_cb': function('term_debugger#term_exit_cb'), 'term_rows': 15})
endfunction

function term_debugger#term_sendkeys(command)
	if !exists('t:term_bufnr')
		echoerr "run :TermDebugger first"
		return
	endif
	let l:cmd = substitute(a:command, g:term_loc_variable, expand('%'), '')
	call term_sendkeys(t:term_bufnr, l:cmd . "\<CR>")
endfunction

command -nargs=+ TermDebugger :call term_debugger#open_terminal(<q-args>)
command -nargs=+ TermSendKeys :call term_debugger#term_sendkeys(<q-args>)
