function s:ShowQuickfixListIfNotEmpty()
	let length = len(getqflist())
	if length > 1
		copen
	elseif length == 1
		copen
		ccl
	elseif length == 0
		echo 'empty quickfix list'
	endif
endfunction

function noplug#FindWord(word)
	if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'cuda'
		let l:extension = '**/*.c* **/*.h*'
	else
		let l:extension = '**/*.' . expand('%:e')
	endif
	" <pattern>: 匹配整个单词
	exe 'vimgrep /\<'.a:word.'\>/ ' . l:extension
	call s:ShowQuickfixListIfNotEmpty()
endfunction

function noplug#FindType(word)
	" <pattern>: 匹配整个单词
	if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'cuda'
		exe 'vimgrep' '/\<\(struct\|union\|class\) '.a:word.'\>/' '**/*.c*' '**/*.h*'
	elseif &filetype == 'python'
		exe 'vimgrep' '/\<class '.a:word.'\>/' '**/*.py'
	elseif &filetype == 'go'
		exe 'vimgrep' '/\<type '.a:word.'\>/' '**/*.go'
	else
		echo 'unsupport filetype: '.&filetype
		return
	endif
	call s:ShowQuickfixListIfNotEmpty()
endfunction

function noplug#FindDefinitionFunction(word)
	if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'cuda'
		exe 'vimgrep' '/\<'.a:word.'\s*(/ **/*.c* **/*.h*'
	elseif &filetype == 'python'
		exe 'vimgrep' '/\<def '.a:word.'(/' '**/*.py'
	elseif &filetype == 'go'
		exe 'vimgrep' '/\<func '.a:word.'(/' '**/*.go'
	else
		echo 'unsupport filetype: '.&filetype
		return
	endif
	call s:ShowQuickfixListIfNotEmpty()
endfunction

function noplug#Ripgrep(args)
	cexpr system('rg --vimgrep ' . a:args)
	call s:ShowQuickfixListIfNotEmpty()
endfunction

" Reference: vim.fandom.com/wiki/Searching_for_files
" find files and populate the quickfix list
" :find :new :edit :open 只能找一个文件，需要配合wildmenu逐级搜索文件夹
" :new 开新的window
" :edit 在当前buffer
" :open 无法使用通配符，不能使用wildmode
" :next 可以打开多个文件
function noplug#FindFiles(filename)
	cexpr system('find . -name "*'.a:filename.'*" | xargs file | sed "s/:/:1:/"')
	set errorformat=%f:%l:%m
	call s:ShowQuickfixListIfNotEmpty()
endfunction

function! noplug#ToggleQuickfix()
	if empty(filter(range(1, winnr('$')), 'getwinvar(v:val, "&buftype") == "quickfix"'))
		copen
	else
		cclose
	endif
endfunction

function noplug#SystemToQf(args)
	cexpr system(a:args)
	call s:ShowQuickfixListIfNotEmpty()
endfunction
