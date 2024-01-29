""""""""""""""""" Copy project_dot_file """"""""""""""""""""""
" Tips: use genproj script to generate project files
" [[palette]]复制常用项目dotfile到当前项目目录			:CopyProjFile
command! -nargs=+ -complete=customlist,project#ProjectFiles -bar CopyProjFile call project#CopyProjFileFunc(<f-args>)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 加载对应的.project.vim文件
function! LoadProjectConfigEachTab()

	" 获取当前的项目根目录
	if v:version >= 800
		let l:project_root = asyncrun#current_root()
	else
		let l:project_root = getcwd()
	endif
	let l:project_vimrc = ''

	let l:possible_vimrc = l:project_root . '/' . g:project_vimrc
	if filereadable(l:possible_vimrc)
		let l:project_vimrc = l:possible_vimrc
	endif

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" 如果找到了project_vimrc文件，则将其加载
	if l:project_vimrc != ''
		execute 'source ' l:project_vimrc
		if get(t:, 'autocd_project_root', 0)
			" 使用tcd命令切换到.project_vimrc文件所在的目录，然后使用source命令加载project_vimrc文件
			execute 'tcd ' . l:project_root 
		endif
	endif

	" Global project config: after sourcing project_vimrc
	augroup codenote_load
		autocmd!
		if get(t:, 'autoload_codenote', 1)
			autocmd BufWinEnter * call LoadCodeNote()
		endif
		autocmd BufEnter * call GetAllCodeLinks()
	augroup END
endfunction

function VimEnterAfterLoadProjectConfig()
	if get(t:, 'autoload_codenote', 1)
		call LoadCodeNote()
	endif
endfunction

function TabNewLoadProjectConfig()
	augroup tab_load_my_project
		autocmd!
		autocmd BufRead * ++once call LoadProjectConfigEachTab()
	augroup END
endfunction

augroup load_my_project
	autocmd!
	" 当Vim启动时，调用LoadProjectConfigEachTab函数加载对应的.project_vimrc文件
	autocmd VimEnter * ++once call LoadProjectConfigEachTab()
	autocmd VimEnter * ++once call VimEnterAfterLoadProjectConfig()
	" 当打开新的缓冲区时，调用LoadProjectConfigEachTab函数加载对应的.project_vimrc文件
	autocmd TabNew * call TabNewLoadProjectConfig()
augroup END
