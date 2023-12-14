""""""""""""""""" Copy project_dot_file """"""""""""""""""""""
" Tips: use genproj script to generate project files

let s:project_file_dir = $HOME . "/vimrc/root/project_dot_files/files"
function! ProjectFiles(ArgLead, CmdLine, CursorPos)
	let files = readdir(s:project_file_dir, { n -> n =~ '^' . a:ArgLead })
	return map(files, 'fnamemodify(v:val, ":t")')
endfunction

function! CopyProjFileFunc(filename)
	let src_path = s:project_file_dir. a:filename
	let dest_path = asyncrun#current_root() . "/" . a:filename
	call system("cp " . src_path . " " . dest_path)
endfunction

" [[palette]]复制常用项目dotfile到当前项目目录			:CopyProjFile
command! -nargs=1 -complete=customlist,ProjectFiles -bar CopyProjFile call CopyProjFileFunc(<q-args>)

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
	" 初始化tab variables(约定一个tab对应一个项目)
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let t:autoload_codenote = 1
	let t:autocd_project_root = 0

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" 如果找到了project_vimrc文件，则将其加载
	if l:project_vimrc != ''
		if !filereadable(l:project_vimrc)
			call writefile([], l:project_vimrc)
		endif
		execute 'source ' l:project_vimrc
		if t:autocd_project_root
			" 使用tcd命令切换到.project_vimrc文件所在的目录，然后使用source命令加载project_vimrc文件
			execute 'tcd ' . l:project_root 
		endif
	" echom "load project " . l:project_root . "'s " . g:project_vimrc . " success"
	else
		" echom "no " . g:project_vimrc . " found"
	endif

	augroup codenote_load
		autocmd!
		if t:autoload_codenote
			autocmd BufWinEnter *.c,*.cpp,*.py,*.rs,*.java,*.go,*.md call LoadCodeNote()
		endif
		autocmd BufEnter * call GetAllCodeLinks()
	augroup END
endfunction

function VimEnterAfterLoadProjectConfig()
	if t:autoload_codenote
		call LoadCodeNote()
	endif
endfunction

function TabNewLoadProjectConfig()
	augroup tab_load_my_project
		autocmd!
		autocmd BufRead * ++once call project#LoadProjectConfigEachTab()
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MkSession
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("*json_encode")
	" [[palette]]创建session文件						:MkSession
	command MkSession call mksession#MkSession(asyncrun#current_root() . '/session.vim')
endif

