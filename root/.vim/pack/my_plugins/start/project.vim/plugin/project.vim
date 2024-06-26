function! LoadProjectConfigEachTab(state)
	" 加载对应的.project.vim文件,  require v:version >= 802
	let l:possible_vimrc = (exists('*asyncrun#current_root') ? asyncrun#current_root() : '.') . '/' . g:project_vimrc
	let l:project_vimrc = ''
	if filereadable(l:possible_vimrc)
		let l:project_vimrc = l:possible_vimrc
	endif

	if l:project_vimrc != ''
		let g:project_load_state = a:state
		execute 'source ' l:project_vimrc
	endif
endfunction

function TabNewLoadProjectConfig()
	augroup tab_load_my_project
		autocmd!
		autocmd BufRead * ++once call LoadProjectConfigEachTab('tabnew')
	augroup END
endfunction

augroup load_my_project
	autocmd!
	" 当打开新的缓冲区时，调用LoadProjectConfigEachTab函数加载对应的.project_vimrc文件
	autocmd TabNew * call TabNewLoadProjectConfig()
augroup END

let g:project_vimrc = get(g:, 'project_vimrc', '.project.vim')
call LoadProjectConfigEachTab('init')
