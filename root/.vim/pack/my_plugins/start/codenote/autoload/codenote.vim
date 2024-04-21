let s:fd = 'fd'

sign define code_note_link text=📓 texthl=Search

" sed -i 's/^+\(.*\) \(.*\)$/\2:\1/' *.md
function! codenote#ConvertFormat(line)
	" 使用 substitute() 函数来交换 +linenumber 和 path/to/filename
	let converted = substitute(a:line, '+\(\d\+\) \(.*\)', '\2:\1', '')
	return converted
endfunction

function codenote#SignCodeLinks()
	if !exists('g:code_link_dict') || !exists('g:coderepo_dir') || !exists('g:noterepo_dir')
		return
	endif
	if g:code_link_dict == {}
		return
	endif
	let l:current_file = expand("%:p")
	if l:current_file[0:len(g:coderepo_dir) - 1] == g:coderepo_dir
		let l:current_file = l:current_file[len(g:coderepo_dir) + 1:]
		if has_key(g:code_link_dict, l:current_file)
			sign unplace * group=code_note_link
			for l:line in g:code_link_dict[l:current_file]
				execute "sign place " . l:line . " line=" . l:line . " group=code_note_link priority=2000 name=code_note_link file=" . l:current_file
			endfor
		endif
	endif
endfunction

function codenote#GetCodeLinkDict()
	if !exists("g:noterepo_dir")
		echoerr "g:noterepo_dir is not set"
		return
	endif

	" 高亮标记支持
	" /path/to/filename.ext:line_number 和
	" +line_number path/to/filename.ext两种格式
	" --max-columns=0 防止rg显示 [ ... xxx more matches ]
	let g:code_links = system("rg -INo --max-columns=0 '(^[\\w\\d\\-./]+:[0-9]+$)|(^\\+[0-9]+ .*$)' " . g:noterepo_dir)
	let g:code_links = split(g:code_links, "\n")

	let g:code_link_dict = {}
	for code_link in g:code_links
		if code_link[0] == "+"
			let l:dest = split(code_link)
			let l:line = l:dest[0][1:]
			let l:file = l:dest[1]
		else
			let l:dest = split(code_link, ":")
			let l:line = l:dest[1]
			let l:file = l:dest[0]
		endif	

		if has_key(g:code_link_dict, l:file)
			call add(g:code_link_dict[l:file], l:line)
		else
			let g:code_link_dict[l:file] = [l:line]
		endif
	endfor
endfunction

function s:CommonPrefixLength(s1, s2)
	let n1 = len(a:s1)
	let n2 = len(a:s2)
	let min_len = min([n1, n2])
	let i = 0

	while i < min_len && a:s1[i] ==# a:s2[i]
		let i += 1
	endwhile

	return i
endfunction

" 根据文件名的绝对路径，来判断当前buffer属于coderepo还是noterepo
" return 'code', 'note', or ''
function s:get_repo_type_of_current_buffer()
	if !exists('g:coderepo_dir') || !exists('g:noterepo_dir')
		echom 'g:coderepo_dir or g:noterepo_dir does not exist!'
		return
	endif

	let bufpath = expand('%:p')
	let prefix_with_coderepo = s:CommonPrefixLength(bufpath, g:coderepo_dir)
	let prefix_with_noterepo = s:CommonPrefixLength(bufpath, g:noterepo_dir)
	if len(g:coderepo_dir) == prefix_with_coderepo && len(g:noterepo_dir) == prefix_with_noterepo
		if prefix_with_coderepo < prefix_with_noterepo
			return 'note'
		elseif prefix_with_coderepo > prefix_with_noterepo
			return 'code'
		else
			return ''
		endif
	elseif len(g:coderepo_dir) == prefix_with_coderepo
		return 'code'
	elseif len(g:noterepo_dir) == prefix_with_noterepo
		return 'note'
	else
		return ''
	endif
endfunction

" 约定第一个tab作为note repo window，第二个tab作为code repo window
function s:goto_code_buffer()
	tabnext 2
endfunction

function s:goto_note_buffer()
	tabfirst
endfunction

function s:open_file(filename)
	execute "tabnew " . a:filename
endfunction

function codenote#OpenNoteRepo()
	call s:open_file(g:noterepo_dir)
	tabmove 0
	execute "tcd " . g:noterepo_dir
	call codenote#GetAllCodeLinks()
endfunction

function s:GoToCodeLink()
	let l:cur = line('.')
	let l:cur_line = getline(l:cur)

	while l:cur >= 0 && l:cur_line !~# s:codelink_regex
		let l:cur -= 1
		let l:cur_line = getline(l:cur)
	endwhile

	if l:cur < 0
		echoerr "No code link found"
		return
	endif

	if l:cur_line[0] == '+'
		let l:dest = split(l:cur_line)
		let l:line = l:dest[0]
		let l:file = l:dest[1]
	else
		" 支持类似 src/execution/operator/aggregate/physical_hash_aggregate.cpp|478 col 7-32| 的格式
		let l:dest = split(l:cur_line, "[:|]")
		let l:line = '+' . split(l:dest[1])[0]
		let l:file = l:dest[0]
		echo l:line l:file
	endif

	if s:only_has_one_repo()
		call codenote#OpenCodeRepo()
	else
		call s:goto_code_buffer()
	endif
	exe "edit " . l:line . " " . g:coderepo_dir . "/" . l:file
endfunction

function s:GoToNoteLink()
	let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:pattern = s:filepath(l:file, l:line)
	" 将 / 转义为 \/
	let l:pattern = substitute(l:pattern, "/", "\\\\/", "g")
	if s:only_has_one_repo()
		call codenote#OpenNoteRepo()
	else
		call s:goto_note_buffer()
	endif
	silent! exe "vim /" . l:pattern . "/g " . g:noterepo_dir . "/**/*.md"
endfunction

function codenote#GoToCodeNoteLink()
	let buf_repo_type = s:get_repo_type_of_current_buffer()
	echom buf_repo_type
	if buf_repo_type == "note"
		call s:GoToCodeLink()
	elseif buf_repo_type == "code"
		call s:GoToNoteLink()
	else
		echoerr "current buffer doesn't belong to codenote repo"
	endif
endfunction

function codenote#OpenCodeRepo()
	call s:open_file(g:coderepo_dir)
	tabmove 1
	call codenote#GetAllCodeLinks()
endfunction

function s:only_has_one_repo()
	return tabpagenr('$') == 1
endfunction

" Supported formats:
" 1) /path/to/file:123
" 2) +123 /path/to/file
" 3) src/execution/operator/aggregate/physical_hash_aggregate.cpp|478 col 7-32|
"
" 3) 源自coc.nvim/nvim lsp在quickfix list中的显示格式
let s:codelink_regex = '[A-Za-z0-9\-./]\+\([:|][0-9]\+\)\|\(^\+[0-9]\+\s\)'

if g:codenote_filepath_style == 'colon'
	function! s:filepath(file, line)
		return a:file . ":" . a:line
	endfunction
	command -nargs=0 Rglink :Rg [\w\d\-./]+:[0-9]+
	"command -nargs=0 Rglink :call RipgrepFzf('rg --column -o --no-heading --color=always --smart-case -- %s || true', '[\w\d\-./]+:[0-9]+', <bang>0)
else
	function! s:filepath(file, line)
		return  "+" . a:line . " " . a:file
	endfunction
	command -nargs=0 Rglink :Rg ^+[0-9]+ .+
	"command -nargs=0 Rglink :call RipgrepFzf('rg --column -o --no-heading --color=always --smart-case -- %s || true', '^\+[0-9]+ .+$', <bang>0)
endif

function s:yank_registers(file, line, content, need_beginline, need_endline, append)
	if a:need_beginline && &filetype != 'markdown'
		let l:beginline = "```" . &filetype . "\n"
	else
		let l:beginline = ""
	endif
	if a:need_endline && &filetype != 'markdown'
		let l:endline = "```\n"
	else
		let l:endline = ""
	endif
	let l:filepath = s:filepath(a:file, a:line)
	if a:append
		let @" .= l:filepath . "\n" . l:beginline . a:content . "\n" . l:endline
		echo "append to @"
	else
		let @" = l:filepath . "\n" . l:beginline . a:content . "\n" . l:endline
	endif
endfunction

" See also: root/vimrc.d/asynctasks.vim
function codenote#YankCodeLink(need_beginline, need_endline, append, goto_buf)
	let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
	let l:line = line(".")
	let l:content = getline(".")
	call s:yank_registers(l:file, l:line, l:content, a:need_beginline, a:need_endline, a:append)
	if a:goto_buf
		if s:only_has_one_repo()
			call codenote#OpenNoteRepo()
		endif
		call s:goto_note_buffer()
	endif
endfunction

function codenote#YankCodeWithFunctionHeader(shortcut)
	let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
	let l:body_line = line(".")
	let l:body_content = getline(".")
	exe "normal " . a:shortcut
	let l:header_line = line(".")
	let l:header_content = getline(".")
	
	call s:yank_registers(l:file, l:header_line, l:header_content, 1, 0, 0)
	call s:yank_registers(l:file, l:body_line, l:body_content, 0, 1, 1)
	
	if s:only_has_one_repo()
		call codenote#OpenNoteRepo()
	endif
	call s:goto_note_buffer()
endfunction

function codenote#YankCodeLinkVisual(need_beginline, need_endline, append, goto_buf) range
	let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
	let [l:line, l:column_start] = getpos("'<")[1:2]
	let l:content = GetVisualSelection()
	call s:yank_registers(l:file, l:line, l:content, a:need_beginline, a:need_endline, a:append)
	if a:goto_buf
		if s:only_has_one_repo()
			call codenote#OpenNoteRepo()
		endif
		call s:goto_note_buffer()
	endif
endfunction

function codenote#YankCodeWithFunctionHeaderVisual(shortcut) range
	let l:file = expand("%:p")[len(g:coderepo_dir) + 1:]
	let [l:body_line, l:column_start] = getpos("'<")[1:2]
	let l:body_content = GetVisualSelection()
	exe "normal " . a:shortcut
	let l:header_line = line(".")
	let l:header_content = getline(".")
	
	call s:yank_registers(l:file, l:header_line, l:header_content, 1, 0, 0)
	call s:yank_registers(l:file, l:body_line, l:body_content, 0, 1, 1)
	
	if s:only_has_one_repo()
		call codenote#OpenNoteRepo()
	endif
	call s:goto_note_buffer()
endfunction

function codenote#GetAllCodeLinks()
	if exists('g:coderepo_dir') && g:coderepo_dir != "" && exists('g:noterepo_dir') && g:noterepo_dir != ""
		call codenote#GetCodeLinkDict()
		call codenote#SignCodeLinks()
		augroup codenote
			autocmd!
			autocmd BufWinEnter * call codenote#SignCodeLinks()
			autocmd BufWritePost *.md call codenote#GetCodeLinkDict()
		augroup END
	endif
endfunction
