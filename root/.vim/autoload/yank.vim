" 路径和行范围的格式统一；调用方决定路径类型、是否显示范围和目标寄存器。
function s:PathLine(path, first, last)
	let l:location = a:path . ':' . a:first
	if a:first != a:last
		let l:location .= '-' . a:last
	endif
	return l:location
endfunction

function s:WithContent(location, first, last)
	return a:location . "\n" . join(getline(a:first, a:last), "\n")
endfunction

function yank#YankPathLine()
	let current_root = asyncrun#current_root()
	let @" = s:PathLine(expand('%:p')[len(current_root) + 1:], line('.'), line('.'))
endfunction

function yank#YankPathLineAndContent() range
	let current_root = asyncrun#current_root()
	" 旧命令只标起始行，继续写未命名寄存器，不随新快捷键改变。
	let l:location = s:PathLine(expand('%:p')[len(current_root) + 1:], a:firstline, a:firstline)
	let @" = s:WithContent(l:location, a:firstline, a:lastline)
endfunction

function yank#YankAbsolutePathLine() range
	call setreg('+', s:PathLine(expand('%:p'), a:firstline, a:lastline))
endfunction

" 绝对路径与行号范围单独占首行，正文保留原始缩进与换行。
function yank#YankLineAndContent() range
	let l:location = s:PathLine(expand('%:p'), a:firstline, a:lastline)
	call setreg('+', s:WithContent(l:location, a:firstline, a:lastline))
endfunction

function yank#YankDiagnostics() range
lua << EOF
local first = vim.fn.eval('a:firstline') - 1
local last = vim.fn.eval('a:lastline') - 1
local diagnostics = vim.tbl_filter(function(d)
  return d.lnum >= first and d.lnum <= last
end, vim.diagnostic.get(0))
table.sort(diagnostics, function(a, b)
  if a.lnum ~= b.lnum then return a.lnum < b.lnum end
  if a.col ~= b.col then return a.col < b.col end
  if a.severity ~= b.severity then return a.severity < b.severity end
  return a.message < b.message
end)
if #diagnostics == 0 then
  vim.notify('所选行没有 diagnostic，剪贴板未更改', vim.log.levels.INFO)
  return
end
local lines = {}
local path = vim.fn.expand('%:p')
for _, d in ipairs(diagnostics) do
  lines[#lines + 1] = string.format('%s:%d: [%s] %s',
    path, d.lnum + 1, vim.diagnostic.severity[d.severity],
    (d.message:gsub('\n', '\n    ')))
end
vim.fn.setreg('+', table.concat(lines, '\n'))
EOF
endfunction

