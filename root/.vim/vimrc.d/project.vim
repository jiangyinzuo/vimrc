" template
let g:user_name = 'Yinzuo Jiang'

function JavaTemplate()
	let l:filename = expand('%:t')
	let l:classname = substitute(l:filename, '\.java$', '', '')
	" first charactor to upper case
	" let l:classname = substitute(l:classname, '\(^\|_\)\(\w\)', '\u\2', 'g')
	" TODO: get package name
	" let l:package = ''
	
	let l:template = 'public class ' . l:classname . ' {'
	" 如果buffer为空
	if line('$') == 1 && getline(1) == ''
		execute 'normal! i' . l:template
	else
		execute 'normal! Go' . l:template
	endif
	normal! Go}
endfunction

function! CCopyRightTemplate()
	let l:line_count = line('$')
	" replace template variables
	let l:year = strftime("%Y")
	execute ":1," . l:line_count . "s/\${__template_year__}/" . l:year . "/g"
	execute ":1," . l:line_count . "s/\${__template_fullname__}/" . g:user_name ."/g"
endfunction

function! HTemplatePragmaOnce()
	call CCopyRightTemplate()
	" 如果buffer为空
	if line('$') == 1 && getline(1) == ''
		execute 'normal! i#pragma once'
	else
		execute 'normal! Go#pragma once'
	endif
endfunction

function! HTemplateHeaderGuard()
	call CCopyRightTemplate()	
	let l:header_guard_prefix = exists('t:header_guard_prefix') ? t:header_guard_prefix : ''
	let l:header_guard_suffix = exists('t:header_guard_suffix') ? t:header_guard_suffix : ''
	let l:filename = expand('%:t')
	let l:filename = substitute(l:filename, '\.', '_', 'g')
	let l:header_guard = l:header_guard_prefix . toupper(l:filename) . l:header_guard_suffix
	
	" 如果buffer为空
	if line('$') == 1 && getline(1) == ''
		execute 'normal! i#ifndef ' . l:header_guard
	else
		execute 'normal! Go#ifndef ' . l:header_guard
	endif
	execute 'normal! Go#define ' . l:header_guard
	normal! Go
	execute 'normal! Go#endif /* ' . l:header_guard . ' */'
endfunction

let g:template_dict = {
	\ 'java': function('JavaTemplate'),
	\ 'h': function('HTemplateHeaderGuard'),
	\ 'c': function('CCopyRightTemplate'),
	\ 'cpp': function('CCopyRightTemplate'),
	\ }
function! LoadTemplate()
	let l:extension = expand('%:e')
	let l:set_autocmd = 1
	" 当创建一个新的文件时，插入模板内容
	if filereadable('.template.' . l:extension)
		let l:filename = '.template.' . l:extension
	else
		let l:filename = expand('~/.vim/template/template.' . l:extension)
		if !filereadable(l:filename)
			let l:set_autocmd = 0
		endif
	endif
	if l:set_autocmd
		execute '0r ' . l:filename
	endif

	" 调用对应的函数插入模板内容
	if exists('t:template_dict') && has_key(t:template_dict, l:extension)
		call t:template_dict[l:extension]()
	elseif has_key(g:template_dict, l:extension)
		call g:template_dict[l:extension]()
	endif
endfunction

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
	let t:autocd_project_root = 1
	
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
		echom "load project " . l:project_root . "'s " . g:project_vimrc . " success"
	else
		echom "no " . g:project_vimrc . " found"
	endif
	
	augroup load_template
		autocmd!
		autocmd BufNewFile * call LoadTemplate()
	augroup END
	
	augroup codenote_load
		autocmd!
		if t:autoload_codenote
			autocmd BufWinEnter *.c,*.cpp,*.py,*.rs,*.java,*.go,*.md call LoadCodeNote()
		endif
		autocmd BufEnter * call GetAllCodeLinks()
	augroup END
endfunction

function VimEnterAfterLoadProjectConfig()
	" 如果当前缓冲区没有打开任何文件，则调用LoadTemplate函数加载模板
	if !filereadable(expand('%'))
		call LoadTemplate()
	endif
	if t:autoload_codenote
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MkSession
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("*json_encode")

function! SerializeValue(Value)
	if type(a:Value) == type(function('function'))
		return string(a:Value)
	elseif type(a:Value) == type({})
		return '{' . join(map(items(a:Value), {idx, item -> '"' . item[0] . '": ' . SerializeValue(item[1])}), ', ') . '}'
	else
		return json_encode(a:Value)
	endif
endfunction

" TODO: 维护一个需要保存的g:variables变量列表
let g:save_variables = ['g:code_link_dict']

function! SaveTabVariables(filename)
	let l:currentTab = tabpagenr()
	let l:numTabs = tabpagenr('$')

	for g_var in g:save_variables
		if exists(g_var)
			let Value = eval(g_var)
			let escaped_value = SerializeValue(Value)
			let escaped_varname = escape(g_var, ' ')
			echo 'let ' . escaped_varname . ' = ' . escaped_value . ''
		endif
	endfor
	echo 'tabfirst'
	for i in range(1, l:numTabs)
		execute 'tabnext' i
		" Output the current tab variables
		for varname in keys(t:)
			let Value = t:[varname]
			let escaped_value = SerializeValue(Value)
			let escaped_varname = escape(varname, ' ')
			echo 'let t:' . escaped_varname . ' = ' . escaped_value . ''
		endfor
		echo 'tabnext'
	endfor

	execute 'tabnext' l:currentTab
endfunction

function! MkSession(sessionfile)
	" Save the session
	execute 'mksession! ' . a:sessionfile

	" Save the tab variables, appended to the session file
	execute 'redir >> ' . a:sessionfile
	call SaveTabVariables(a:sessionfile)
	redir END
endfunction
" [[palette]]创建session文件						:MkSession
command MkSession call MkSession(asyncrun#current_root() . '/session.vim')
endif

""""""""""""""""" Copy project_dot_file """"""""""""""""""""""
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
