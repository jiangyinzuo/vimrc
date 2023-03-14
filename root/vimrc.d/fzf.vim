" Reference: https://github.com/junegunn/fzf/blob/master/README-VIM.md

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
" - Note that this array is passed as arguments to fzf#vim#with_preview function.
" - To learn more about preview window options, see `--preview-window` section of `man fzf`.
let g:fzf_preview_window = ['up,70%', 'ctrl-/']


" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function s:append_current_line(lines)
	call append('.', a:lines)
endfunction

let g:fzf_action = {
			\ 'ctrl-a': function('s:append_current_line'),
			\ 'ctrl-q': function('s:build_quickfix_list'),
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }


command! -bang -nargs=* Rgdoc
			\ call fzf#vim#grep(
			\   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>).' ~/.vim/doc/*', 1,
			\ fzf#vim#with_preview(), <bang>0)


function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' asyncrun#get_root('%')

" See https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf-inside-terminal-buffer
" On :LS!, <bang> evaluates to '!', and '!0' becomes 1
" The query history for this command will be stored as 'ls' inside g:fzf_history_dir.
" The name is ignored if g:fzf_history_dir is not defined.
let g:fzf_history_dir = '~/.cache/fzf_history_dir'
command! -bang -complete=dir -nargs=? LS
		\ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))

function s:exec_command_palette(line)
	let l:cmd = filter(split(a:line, '\t'), 'v:val != ""')
	" 把l:cmd放到Command Line且不执行
	call feedkeys(l:cmd[1])
endfunction

command! -bang -nargs=0 Palette
			\ call fzf#run(fzf#wrap('palettle', {'source': 'cat ~/.vim/doc/palette.cnx', 'sink': function("s:exec_command_palette")}, <bang>0))

" See: github.com/junegunn/fzf.vim/issues/1037
"" HelpRg command -- like helpgrep but with FZF and ripgrep
let g:helppaths = uniq(sort(split(globpath(&runtimepath, 'doc/', 1), '\n')))

function ListDocs(A, L, P)
	let result = ''
	for helppath in g:helppaths
		let result = result . system("ls " . helppath . " | grep ^" . a:A)
	endfor
	return result
endfunction

command! -bang -nargs=? -complete=custom,ListDocs HelpRg
			\ if <q-args> == "" |
			\		call fzf#vim#grep(
			\			'rg --column --line-number --no-heading --color=always --smart-case -g "*.txt" -g "*.cnx" "" '. join(g:helppaths), 1,
			\			{}, <bang>0) |
			\ else |
			\		call fzf#vim#grep(
			\			'rg --column --line-number --no-heading --color=always --smart-case  -g "' . <q-args> . '" "" '. join(g:helppaths), 1,
			\			{}, <bang>0) |
			\ end

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
