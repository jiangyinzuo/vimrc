" Reference: https://github.com/junegunn/fzf/blob/master/README-VIM.md

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" - Popup window (center of the screen)
let g:fzf_layout = { 'window': { 'width': 0.99, 'height': 0.99 } }

Plug 'junegunn/fzf.vim'

" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
" - Note that this array is passed as arguments to fzf#vim#with_preview function.
" - To learn more about preview window options, see `--preview-window` section of `man fzf`.
let g:fzf_preview_window = ['up,40%,', 'ctrl-/']

" An action can be a reference to a function that processes selected lines
function! FzfActionBuildQf(lines)
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
	copen
	cc
endfunction

function FzfActionAppendLine(lines)
	call append('.', a:lines)
endfunction

let g:fzf_action = {
			\ 'ctrl-a': function('FzfActionAppendLine'),
			\ 'ctrl-q': function('FzfActionBuildQf'),
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }


function! s:find_git_root()
	return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" [[palette]]FZF搜索当前项目目录下的文件并打开			:Files
command! ProjectFiles execute 'Files' asyncrun#current_root('%')

" See https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf-inside-terminal-buffer
" On :LS!, <bang> evaluates to '!', and '!0' becomes 1
" The query history for this command will be stored as 'ls' inside g:fzf_history_dir.
" The name is ignored if g:fzf_history_dir is not defined.
" [[palette]]fzf ls							:LS
command! -bang -complete=dir -nargs=? LS
			\ call fzf#run(fzf#wrap({'source': 'ls', 'dir': <q-args>}, <bang>0))

""""""""""""""""" Z """"""""""""""""""""
" https://gist.github.com/jiangyinzuo/d9c985999f76864ac192edfdacdadcce
function Z(query, sink)
	let l:cmd = "awk -f " . $VIMRC_ROOT . "/z.awk regex=" . a:query . " ~/.z "
	call fzf#run(fzf#wrap({'source': l:cmd, 'sink': a:sink, 'options': ['--query', a:query, '--prompt', 'Z ' . a:sink . '>', '--color', 'hl:148,hl+:190']}))
endfunction
" [[palette]]FZF搜索z并cd到目录					:Z
command! -bang -nargs=? Z call Z(<q-args>, 'cd')
" [[palette]]FZF搜索z并tcd到目录					:TZ
command! -bang -nargs=? TZ call Z(<q-args>, 'tcd')
" [[palette]]FZF搜索z并lcd到目录					:LZ
command! -bang -nargs=? LZ call Z(<q-args>, 'lcd')
" [[palette]]FZF搜索z并Ex到目录					:Zex
command! -bang -nargs=? Zex call Z(<q-args>, 'Ex')

""""""""""""""""" Fd 类""""""""""""""""
command! -nargs=* -bang Fd call fzf#run({'source': 'fd ' . <q-args>, 'sink': function("s:paste_word")})
command! -bang -nargs=0 Directories
			\ call fzf#run(fzf#wrap({'source': 'fd -i -t d', 'dir': <q-args>, 'sink': 'e'}, <bang>0))
command! -nargs=0 DirectoriesPaste call fzf#run({'source': 'fd -i -t d', 'sink': function("s:paste_word")})

" Markdown等文本编辑添加链接：
" 1) fd > path.txt  预处理得到项目所有文件路径
" 2）:PathPaste模糊查找文件路径
"
" [[palette]]FZF搜索文件路径并插入到当前光标位置			:Path
command! -bang -nargs=0 PathPaste
			\ call fzf#run(fzf#wrap('path', {'source': 'cat ' .. asyncrun#get_root('%') .. '/path.txt', 'sink': function("s:paste_word")}, <bang>0))

" 在线查找path
command! -bang -nargs=0 PathLivePaste call fzf#run({'sink': function("s:paste_word")})

function CdDirectory(dirname)
	exe "normal! :e " . a:dirname . "\<CR>"
	exe "normal! :cd " . a:dirname . "\<CR>"
endfunction

command! -bang -complete=dir -nargs=? Cd
			\ call fzf#run(fzf#wrap({'source': 'fd -i -t d', 'dir': <q-args>, 'sink': function("CdDirectory")}, <bang>0))

"""""""""""""""""""""""""""""""""""""

function s:paste_word(word)
	echo a:word
	exe "normal! a" . a:word
endfunction

" hashtag排除包含各类字符
" rg -e "#[^_\d()（）{}#\s'/\\[\]:：;?%][^()（）{}#\s'/\\[\]:：;?%]{1,40}" -N -I -o | sort | uniq > hashtag.txt
" [[palette]]FZF搜索hashtag并paste					:Hashtag
command! -bang -nargs=0 Hashtag
			\ call fzf#run(fzf#wrap('hashtag', {'source': 'cat ' .. $DOC2 .. '/hashtag.txt', 'sink': function("s:paste_word")}, <bang>0))

" See: github.com/junegunn/fzf.vim/issues/1037
" HelpRg command -- like helpgrep but with FZF and ripgrep
let g:helppaths = uniq(sort(split(globpath(&runtimepath, 'doc/', 1), '\n')))

function ListDocs(A, L, P)
	let result = ''
	for helppath in g:helppaths
		let result = result . system("ls " . helppath . " | grep ^" . a:A)
	endfor
	return result
endfunction

""""""""""""""""""" Rg 类""""""""""""""""
command! -bang -nargs=* Rgdoc
			\ call fzf#vim#grep(
			\   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>).' ~/.vim/doc/*', 1,
			\ fzf#vim#with_preview(), <bang>0)

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

command! WikiLink call fzf#vim#grep("rg --column --line-number --no-heading '\\[\\[[^$\\#]+\\]\\]' " . $DOC2, 0, fzf#vim#with_preview(), <bang>0)
" 为了同时匹配相对路径和绝对路径，只通过%:t保留文件名，去文件路径
command! WikiLinkCur call fzf#vim#grep("rg --column --line-number --no-heading '\\[\\[[^$\\#]*". expand("%:t") ."[^$\\#]*\\]\\]' " . $DOC2, 0, fzf#vim#with_preview(), <bang>0)
"""""""""""""""""""""""""""""""""""""""

source ~/.vim/vimrc.d/fzf/palette.vim
source ~/.vim/vimrc.d/fzf/quickfix.vim
source ~/.vim/vimrc.d/fzf/tags.vim
source ~/.vim/vimrc.d/fzf/tabs.vim
