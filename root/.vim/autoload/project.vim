let s:project_file_dir = $HOME . "/vimrc/root/project_dot_files/files"
function! project#ProjectFiles(ArgLead, CmdLine, CursorPos)
	let files = readdir(s:project_file_dir, { n -> n =~ '^' . a:ArgLead })
	return map(files, 'fnamemodify(v:val, ":t")')
endfunction

function! project#CopyProjFileFunc(...)
	if a:0 > 2
		echoerr "args must less than 2"
		return
	endif
	let src_path = s:project_file_dir . '/' . a:1
	if a:0 == 1
		let dest_path = asyncrun#current_root() . "/" . a:1
	else
		let dest_path = asyncrun#current_root() . "/" . a:2
	endif
	call system("cp " . src_path . " " . dest_path)
endfunction

