""""""""""""" Ctags 类""""""""""""""""""
" 作者：成隽
" 链接：https://www.zhihu.com/question/26248191/answer/2680677733
" 来源：知乎
function s:tag_sink(line)
	let l:lines = split(a:line)[1]
	let l:lines = split(l:lines, ':')
	call GoToFile(l:lines[0], l:lines[1])
endfunction

function fzf_custom#tags#CTags(query, fullscreen)
	let tags = join(map(tagfiles(), 'fzf#shellescape(fnamemodify(v:val, ":p"))'))
	" TODO: 处理多tag文件
	echom tags

	" 输出不以!开头的行
	" ^! 是正则表达式，表示以!开头的行
	" !/^!/ 是否定模式，用于匹配不以!开头的行
	let l:cmd = "awk -f " . $VIMRC_ROOT . "/process_ctags.awk regex=" . a:query . " " . tags

	try
		return fzf#run(fzf#wrap({
					\ 'source': l:cmd,
					\ 'sink': function('s:tag_sink'),
					\ 'options': ['--query', a:query, '--prompt', 'CTags> ', '--color', 'hl:148,hl+:190' ],
					\ }))
	catch
		echom v:exception
	endtry
endfunction

" Example:
" a                   5 hello.py         a = 3
function s:global_sink(line)
	let l:lines = split(a:line)
	call GoToFile(l:lines[2], l:lines[1])
endfunction

function s:global(cmd)
	let l:source = systemlist(a:cmd)
	if len(l:source) == 1
		" 只有一行结果时，直接跳转
		call s:global_sink(l:source[0])
		return
	endif
	" 有多行结果时，使用fzf选择
	try
		return fzf#run(fzf#wrap({
					\ 'source': l:source,
					\ 'sink': function('s:global_sink'),
					\ 'options': [ '--prompt', 'Global> ', '--color', 'hl:148,hl+:190' ],
					\ }))
	catch
		echom v:exception
	endtry
endfunction

function! s:global_sym(query)
	let l:cmd = 'global -s -rx ' . a:query
	call s:global(l:cmd)
endfunction

function! s:global_def(query)
	let l:cmd = 'global -d -rx ' . a:query
	call s:global(l:cmd)
endfunction

function fzf_custom#tags#GlobalSym()
	let l:cmd = 'GTAGSDBPATHGTAGSROOT=' . getcwd() . ' global -c'
	return fzf#run(fzf#wrap({
				\ 'source': l:cmd,
				\ 'sink': function('s:global_sym'),
				\ 'options': [ '--prompt', 'Global -c> ', '--color', 'hl:148,hl+:190' ],
				\ }))	
endfunction

function fzf_custom#tags#GlobalDef()
	let l:cmd = 'GTAGSROOT=' . getcwd() . ' global -c'
	let l:source = systemlist(l:cmd)
	return fzf#run(fzf#wrap({
				\ 'source': l:source,
				\ 'sink': function('s:global_def'),
				\ 'options': [ '--prompt', 'Global -c> ', '--color', 'hl:148,hl+:190' ],
				\ }))
endfunction

