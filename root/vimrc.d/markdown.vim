Plug 'godlygeek/tabular', { 'for': 'markdown' }
Plug 'preservim/vim-markdown', { 'for': 'markdown' }

let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1

if (has('unix') && exists('$WSLENV'))
	let g:basepath='D:/doc2'
	let g:wsl_basepath = '/mnt/d/doc2'

	function MdPreview()
		let l:uri = expand("%:p")
		let l:uri = substitute(l:uri, '/mnt/d', 'D:', '')
		let l:job = job_start('x-www-browser "' . l:uri . '"')
	endfunction
	nnoremap <silent> gx :call MdPreview()<CR>

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
