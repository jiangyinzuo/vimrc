Plug 'godlygeek/tabular', { 'for': 'markdown' }
" See: https://github.com/preservim/vim-markdown/pull/633
Plug 'jiangyinzuo/vim-markdown', { 'for': 'markdown' }

let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_conceal_code_blocks = 0

if (has('unix') && exists('$WSLENV'))
	" TODO: get root by ascynrun#get_root
	let g:basepath='D:/doc2'
	let g:wsl_basepath = $DOC2

	" xdg-open <uri>
	" cmd.exe /C start "" 需要使用cmd.exe /c mklink创建软链接
	" explorer.exe
	"
	" do not work.
	"
	" x-www-browser <uri> need `update-alternatives --config x-www-browser` to setup default programs.
	" 
	" sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser <browser-path> <priority_as_integer>
	"
	" Example:
	" sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser '/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe' 200
	" sudo update-alternatives --config x-www-browser
	"
	function MdPreview()
		let l:uri = expand("%:p")
		let l:uri = substitute(l:uri, '/mnt/d', 'D:', '')
		let l:job = job_start('x-www-browser "' . l:uri . '"')
	endfunction
	command! -nargs=0 MdPreview call MdPreview()
	
	function MdStart()
		let l:uri = getline('.')
		let l:root = asyncrun#get_root(l:uri)
		let l:root = substitute(l:root, '/mnt/d', 'D:', '')
		let l:uri = l:root . '/' . l:uri
		if len(l:uri) != 0
			if l:uri[0] == '/'
				let l:uri = g:basepath . l:uri	
			elseif l:uri[0] == '.'
				let l:uri = expand("%:p:h") . l:uri[1:]
				let l:uri = substitute(l:uri, '/mnt/d', 'D:', '')
			endif
			let l:job = job_start('wslview "' . l:uri . '"')
		endif
	endfunction
	command! -nargs=0 MdStart call MdStart()
	
	function MdOpenInBrowser()
		let l:uri = matchstr(getline('.'), '(\zs.\{-}\ze)')
		if len(l:uri) != 0
			if l:uri[0] == '/'
				let l:uri = g:basepath . l:uri	
			elseif l:uri[0] == '.'
				let l:uri = expand("%:p:h") . l:uri[1:]
				let l:uri = substitute(l:uri, '/mnt/d', 'D:', '')
			endif
			let l:job = job_start('x-www-browser "' . l:uri . '"')
		endif
	endfunction
	command! -nargs=0 MdOpenInBrowser call MdOpenInBrowser()

	function MdOpenInVim()
		let l:uri = matchstr(getline('.'), '(\zs.\{-}\ze)')
		if len(l:uri) != 0 && (l:uri[0] == '/' || l:uri[0] == '.')
			if l:uri[0] == '/'
				let l:uri = g:wsl_basepath . l:uri	
			endif
			exe 'edit ' . l:uri
		endif
	endfunction
	command! -nargs=0 MdOpenInVim call MdOpenInVim()
endif

function! NumberHeadings()
	let last_level = 0
	let l:empty = [0, 0, 0, 0, 0, 0]
  let l:count = [0, 0, 0, 0, 0, 0]
	execute "normal! gg"
	let l:last_line = line("$")
  for i in range(1, l:last_line)
    let line_text = getline(".")
    let line_level = len(matchstr(line_text, '^#\+\s')) - 1
    if line_level > 0
			if line_level == 1
				let l:count = [l:count[0] + 1] + l:empty[1 : 5]
			else
      	let l:count = l:count[0 : line_level - 2] + [l:count[line_level - 1] + 1] + l:empty[line_level + 1 : 5]
			endif
			" 1.
			" 1.1.
			" 1.1.1.
"       let number_text = join(l:count[0 : line_level - 1], '.') . '.'
" 			let line_text = substitute(line_text, '^\(\s*#\+\s*\)\(\(\d\+\.\)*\d\+\. \)\?', '\1', '')
			" 1
			" 1.1
			" 1.1.1
      let number_text = join(l:count[0 : line_level - 1], '.')
      let line_text = substitute(line_text, '^\(\s*#\+\s*\)\(\d\+\.\)*\d\+\s\+', '\1', '')

      call setline('.', matchstr(line_text, '^\s*#\+') . ' ' . number_text . matchstr(line_text, '^\s*#\+\zs.*'))
    endif
    execute "normal! j"
	endfor
endfunction

command! NumberHeadings :call NumberHeadings()

function! RemoveNumberHeadings()
    execute "normal! gg"
    let l:last_line = line("$")
    for i in range(1, l:last_line)
        let line_text = getline(".")
				" 1.
				" 1.1.
				" 1.1.1.
        " let line_text = substitute(line_text, '^\(\s*#\+\s*\)\(\d\+\.\)*\d\+\. ', '\1', '')
				" 1
				" 1.1
				" 1.1.1
				let line_text = substitute(line_text, '^\(\s*#\+\s*\)\(\d\+\.\)*\d\+ ', '\1', '')
        call setline('.', line_text)
        execute "normal! j"
    endfor
endfunction

command! RemoveNumberHeadings :call RemoveNumberHeadings()

