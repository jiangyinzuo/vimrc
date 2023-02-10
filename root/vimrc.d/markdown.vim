Plug 'godlygeek/tabular', { 'for': 'markdown' }
Plug 'preservim/vim-markdown', { 'for': 'markdown' }

let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1

if (has('unix') && exists('$WSLENV'))
	" TODO: get root by ascynrun#get_root
	let g:basepath='D:/doc2'
	let g:wsl_basepath = '/mnt/d/doc2'

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
