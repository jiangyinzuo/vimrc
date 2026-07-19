function! s:OpenDT()
    " 获取当前文件的绝对路径，并将 Windows 的 \ 统一转换为 / 方便正则匹配
    let l:current_file = tr(expand('%:p'), '\', '/')
    if empty(l:current_file)
        echo "当前 buffer 没有有效的文件路径"
        return
    endif
    " 使用 \(.*\)/sql/\(.*\)\.sql$ 确保精准匹配最后一段路径
    if l:current_file =~# '/sql/.*\.sql$'
        let l:target_file = substitute(l:current_file, '\(.*\)/sql/\(.*\)\.sql$', '\1/expected/\2.out', '')
    elseif l:current_file =~# '/expected/.*\.out$'
        let l:target_file = substitute(l:current_file, '\(.*\)/expected/\(.*\)\.out$', '\1/sql/\2.sql', '')
    elseif l:current_file =~# '/input/.*\.source$'
        let l:target_file = substitute(l:current_file, '\(.*\)/input/\(.*\)\.source$', '\1/output/\2.source', '')
    elseif l:current_file =~# '/output/.*\.source$'
        let l:target_file = substitute(l:current_file, '\(.*\)/output/\(.*\)\.source$', '\1/input/\2.source', '')
    else
        echo "当前文件不属于 sql/expected 或input/output 目录"
        return
    endif
    " 垂直分屏并打开目标文件
    execute 'vsp' fnameescape(l:target_file)
endfunction
" 注册命令
command! OpenDT call s:OpenDT() 
