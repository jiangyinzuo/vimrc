" Reference: https://github.com/junegunn/fzf/blob/master/README-VIM.md

" - Popup window (center of the screen)
let g:fzf_layout = { 'window': { 'width': 0.99, 'height': 0.99 } }

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

" 不要让fzf.vim帮我们定义:Files, :History
command -bang -nargs=? -complete=dir Files
	\ call fzf#vim#files(<q-args>, {'options': ['--info=inline', '--preview', '$VIMRC_ROOT/scripts/preview.sh {}']}, <bang>0)
function! s:history(arg, bang)
	let bang = a:bang || a:arg[len(a:arg)-1] == '!'
	if a:arg[0] == ':'
		call fzf#vim#command_history(bang)
	elseif a:arg[0] == '/'
		call fzf#vim#search_history(bang)
	else
		call fzf#vim#history({'options': ['--info=inline', '--preview', '$VIMRC_ROOT/scripts/preview.sh {}']}, bang)
	endif
endfunction
command -bang -nargs=* History call s:history(<q-args>, <bang>0)
" [[palette]]FZF搜索当前项目目录下的文件并打开			:Files
command -nargs=0 ProjectFiles execute 'Files' asyncrun#current_root()

command! -nargs=0 GitUnmergedRaw call fzf#run(fzf#wrap({'source': 'git diff --name-only --diff-filter=U', 'sink': 'e'}))
command! -nargs=0 GitUnmerged call fzf#run(fzf#wrap({'source': 'git diff --name-only --diff-filter=U', 'sink': function('fzf_custom#fzf#mergetool_start')}))
command! -nargs=0 GitUntracked call fzf#run(fzf#wrap({'source': 'git ls-files --others --exclude-standard', 'sink': 'e'}))
command! -nargs=0 GitStaged call fzf#run(fzf#wrap({'source': 'git diff --name-only --cached', 'sink': 'e'}))
command! -nargs=0 GitModified call fzf#run(fzf#wrap({'source': 'git ls-files -m', 'sink': 'e'}))
command! -nargs=0 GitDeleted call fzf#run(fzf#wrap({'source': 'git ls-files -d', 'sink': 'e'}))
command! -nargs=0 GitRenamed call fzf#run(fzf#wrap({'source': 'git ls-files -t', 'sink': 'e'}))
command! -nargs=0 GitUnstaged call fzf#run(fzf#wrap({'source': 'git ls-files -o --exclude-standard', 'sink': 'e'}))

" See https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf-inside-terminal-buffer
" On :LS!, <bang> evaluates to '!', and '!0' becomes 1
" The query history for this command will be stored as 'ls' inside g:fzf_history_dir.
" The name is ignored if g:fzf_history_dir is not defined.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" [[palette]]fzf ls							:LS
command! -bang -complete=dir -nargs=? LS
			\ call fzf#run(fzf#wrap({'source': 'ls', 'dir': <q-args>}, <bang>0))

""""""""""""""""" Fd 类""""""""""""""""
command! -nargs=* -bang Fd call fzf#run(fzf#wrap({'source': 'fd ' . <q-args>, 'sink': 'e', 'options': ['--prompt', 'fd ' . <q-args> . ' > ']}))
command! -nargs=* -bang FdPaste call fzf#run(fzf#wrap({'source': 'fd ' . <q-args>, 'sink': function("s:paste_word"), 'options': ['--prompt', 'fd ' . <q-args> . ' > ']}))
command! -bang -nargs=0 Directories
			\ call fzf#run(fzf#wrap({'source': 'fd -i -t d', 'dir': <q-args>, 'sink': 'e'}, <bang>0))
command! -nargs=0 DirectoriesPaste call fzf#run({'source': 'fd -i -t d', 'sink': function("s:paste_word")})

" Markdown等文本编辑添加链接：
" 1) fd > path.txt  预处理得到项目所有文件路径
" 2）:PathPaste模糊查找文件路径
"
" [[palette]]FZF搜索文件路径并插入到当前光标位置			:Path
command! -bang -nargs=0 PathPaste
			\ call fzf#run(fzf#wrap('path', {'source': 'cat ' .. asyncrun#current_root() .. '/path.txt', 'sink': function("s:paste_word")}, <bang>0))

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
	exe "normal! a" . a:word
endfunction

" hashtag排除包含各类字符
" rg -e "#[^_\d()（）{}#\s'/\\[\]:：;?%][^()（）{}#\s'/\\[\]:：;?%]{1,40}" -N -I -o | sort | uniq > hashtag.txt
" [[palette]]FZF搜索hashtag并paste					:Hashtag
command! -bang -nargs=0 Hashtag
			\ call fzf#run(fzf#wrap('hashtag', {'source': 'cat ' .. $DOC2 .. '/hashtag.txt', 'sink': function("s:paste_word")}, <bang>0))

""""""""""""""""""" Rg 类""""""""""""""""
command! -bang -nargs=* RgwithArgs
			\ call fzf#vim#grep(
			\   'rg --column --line-number --no-heading --color=always '. <q-args>, 1,
			\ fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rgdoc
			\ call fzf#vim#grep(
			\   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>).' ~/.vim/doc/*', 1,
			\ fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=custom,fzf_custom#rg#ListDocs HelpRg call fzf_custom#rg#HelpRg(<q-args>, <bang>0)
command! -bang -nargs=0 HelpRgCword call fzf_custom#rg#HelpRg(expand('<cword>'), <bang>0)
autocmd FileType help nnoremap <buffer> <silent> <leader>gr :HelpRgCword<CR>

command! WikiLink call fzf#vim#grep("rg --column --line-number --no-heading '\\[\\[[^$\\#]+\\]\\]' " . $DOC2, 0, fzf#vim#with_preview(), <bang>0)
" 为了同时匹配相对路径和绝对路径，只通过%:t保留文件名，去文件路径
command! WikiLinkCur call fzf#vim#grep("rg --column --line-number --no-heading '\\[\\[[^$\\#]*". expand("%:t") ."[^$\\#]*\\]\\]' " . $DOC2, 0, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* GitGrep
	\ call fzf#vim#grep(
	\   'git grep --line-number -- '.fzf#shellescape(<q-args>),
	\   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

"""""""""""""""""""""""""""""""""""""""

" palette在vimscript注释中的格式如下，记得用tab键分隔
" [[palette]]命令面板						:Palette
command! -nargs=0 Palette call fzf_custom#palette#Palette()
command! -nargs=0 Quickfix call fzf_custom#quickfix#Quickfix()
command! -nargs=0 Tabs call fzf_custom#tabs#FzfTabs()

" 可以输入0-1个正则表达式, 满足正则的行才会显示
" [[palette]]FZF查询ctags						:CTags
command! -nargs=? -bang CTags call fzf_custom#tags#CTags(<q-args>, <bang>0)

" [[palette]]Global 查找符号						:GlobalSym
command -nargs=0 GlobalSym call fzf_custom#tags#GlobalSym()
" [[palette]]Global 查找定义						:GlobalDef
command -nargs=0 GlobalDef call fzf_custom#tags#GlobalDef()

" [[palette]]读取常用项目配置文件			:ReadProjectFile
command! -nargs=0 ReadProjectFile call fzf#run(fzf#wrap({'source': "find ~/vimrc/project_files -type f", 'sink': 'read', 'options': ['--prompt', 'ProjectFile > ', '--preview', 'cat {}', '--preview-window', 'up,60%']}))

command! -nargs=0 BackupFile call fzf#run(fzf#wrap({'source': "find ~/.vim/backup" . expand('%:p') . '* -type f', 'sink': function("fzf_custom#fzf#backup"), 'options': ['--tac', '--no-sort', '--prompt', 'BackupFile> ', '--preview', 'head -n 1000 {}', '--preview-window', 'up,60%']}))

command! -nargs=0 Dictionary call fzf#run(fzf#wrap('dictionary', {'source': 'cat ' . &dict, 'sink': function("s:paste_word")}))
