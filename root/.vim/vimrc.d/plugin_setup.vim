" Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#s_next = 1

" showkey -a 查看组合键的编码
" M-c M-[ 存在bug
" 在终端下按下 ALT+X，那么终端软件将会发送 <ESC>x 两个字节过去，字节码为：0x27, 0x78。
" See Also:
" https://superuser.com/questions/1554782/why-was-the-meta-key-replaced-on-modern-terminals
" https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
" https://www.skywind.me/blog/archives/2021
" :h set-termcap
" 给copilot.vim, vim-move, codeium.vim插件使用
execute "set <M-h>=\eh"
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
execute "set <M-l>=\el"
execute "set <M-n>=\en"
execute "set <M-p>=\ep"
execute "set <M-x>=\ex"
execute "set <M-w>=\ew"

" default s: delete [count] charaters and start insert
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T

let g:matchup_override_vimtex = 1
let g:matchup_surround_enabled = 1
let g:loaded_matchit = 1
let g:matchup_matchparen_enabled = 0

let g:fern#renderer = "nerdfont"
let g:fern#default_hidden = 1

if v:version >= 801
	set nocursorline " vim-css-color插件下，set cursorline有性能问题
	" let g:AutoPairsMapBS = 1
	if has('nvim')
		" confict with neovim luasnip
		let g:AutoPairs = {'"': '"', '[': ']', '''''': '''''', '(': ')', '''''''''''': '''''''''''', '{': '}', '"""': '"""'}
	else
		let g:AutoPairs = {'```': '```',  '"': '"', '[': ']', '''''': '''''', '(': ')', '''''''''''': '''''''''''', '{': '}', '"""': '"""'}
	endif
	let g:AutoPairsMapSpace = 0
	" 只在后面有空格或者是行尾时，才补全右括号
	let g:AutoPairsCompleteOnlyOnSpace = 1
	
" Plug 'jiangyinzuo/vim-visual-multi', {'branch': 'master'}
	let g:VM_mouse_mappings             = 1
	let g:VM_theme                      = 'iceblue'
	let g:VM_highlight_matches          = 'underline'

	let g:VM_maps = {}
	let g:VM_maps['I CtrlF'] = ''
	let g:VM_maps['I Return'] = ''
	" Vim9 has a bug when maps to Esc
	" https://github.com/mg979/vim-visual-multi/issues/220
	let g:VM_maps['Exit'] = '<C-c>'
	let g:VM_maps['Add Cursor Down'] = '<C-j>'
	let g:VM_maps['Add Cursor Up'] = '<C-k>'
	let g:VM_maps['Add Cursor At Pos'] = '<C-h>'
	let g:VM_maps['Motion j'] = '<Down>'
	let g:VM_maps['Motion k'] = '<Up>'
	let g:VM_maps['Motion l'] = '<Right>'
	let g:VM_maps['Motion h'] = '<Left>'
endif

let test#strategy = "asyncrun_background_term"
let test#python#pytest#executable = 'python3 -m pytest'
let test#rust#cargotest#test_options = { 'nearest': ['--', '--nocapture', '--exact'], 'file': [] }

let g:mundo_help = 1
let g:mundo_preview_bottom = 1
let g:mundo_preview_height = 8
let g:mundo_right = 1

let g:templates_no_builtin_templates = 1
" autocmd may slow down vim startup time for deep directory
let g:templates_no_autocmd = 1
" Do not search too many parent directories, it is slow.
let g:templates_search_height = 1
	
let g:maximizer_set_default_mapping = 0
let g:maximizer_set_mapping_with_bang = 0
nnoremap <silent><C-w>m :MaximizerToggle<CR>
vnoremap <silent><C-w>m :MaximizerToggle<CR>gv
inoremap <silent><C-w>m <C-o>:MaximizerToggle<CR>

if v:version >= 800
	let g:far#source = 'rg'
	let g:far#enable_undo = 1
	if exists('$WSLENV') " :Far command is slow in WSL2
		let g:far#auto_preview = 0
		let g:far#auto_preview_on_start = 0
	endif
	" 大多数情况下使用coc-ultisnips的回车键补全，若遇到tb23
	" 这样的补全，使用F12
	let g:UltiSnipsExpandTrigger="<f12>"
	
	" 默认csv带有header
	let g:rbql_with_headers = 1
	let g:rainbow_comment_prefix = '#'
	" 不显示行列位置，防止覆盖search mode下的shortmess提示信息
	let g:disable_rainbow_hover = 1
	if has('patch-9.1.497') || has('nvim-0.11.0')
		" 禁用rainbow_csv的高亮
		let g:rcsv_colorlinks = ['NONE', 'NONE']
	endif
	let g:open_gitdiff_exclude_patterns = ['\.pdf$', '\.jpg$', '\.png$', '\.eps$']
	let g:open_gitdiff_qf_nmaps = {'open': '<leader>df', 'next': '<leader>dn', 'prev': '<leader>dp'}
	let command_def = 'command -nargs=* '
	if v:version >= 901
			" open_gitdiff#comp#Complete is implemented with vim9class
			let command_def .= '-complete=custom,open_gitdiff#comp#Complete '
	endif
	exe command_def . 'GitDiffAll call open_gitdiff#OpenAllDiffs(<f-args>)'
	exe command_def . 'GitDiffThisTab call open_gitdiff#OpenDiff("tabnew", <f-args>)'
	exe command_def . 'GitDiffThis call open_gitdiff#OpenDiff("enew", <f-args>)'

	exe command_def . 'FZFGitDiffTab call open_gitdiff#select("tabnew", function("open_gitdiff#fzf#view"), <f-args>)'
	exe command_def . 'FZFGitDiff call open_gitdiff#select("enew", function("open_gitdiff#fzf#view"), <f-args>)'

	exe command_def . 'QuickUIGitDiffTab call open_gitdiff#select("tabnew", function("open_gitdiff#quickui#listbox#view"), <f-args>)'
	exe command_def . 'QuickUIGitDiff call open_gitdiff#select("enew", function("open_gitdiff#quickui#listbox#view"), <f-args>)'

	exe command_def . 'QfGitDiff call open_gitdiff#select("enew", function("open_gitdiff#quickfix#view"), <f-args>)'
	command -nargs=+ -complete=customlist,fugitive#LogComplete GitDiff2Paths call open_gitdiff#open_diff_by_path(<f-args>)
endif

let g:caser_prefix = 'gs'

let g:MergetoolSetLayoutCallback = function('mergetool_custom#MergetoolLayoutCallback')

" 即使pdf位于wsl中，typst也可以使用windows下的pdf阅读器
let g:typst_pdf_viewer = 'SumatraPDF.exe'

let g:mdip_imgdir = '.'
let g:mdip_wsl_path = '\\\\wsl.localhost\\Ubuntu-22.04'
function! g:LatexPasteImage(relpath)
	execute "normal! i\\includegraphics{" . a:relpath . "}\r\\caption{I"
	let ipos = getcurpos()
	execute "normal! a" . "mage}"
	call setpos('.', ipos)
	execute "normal! ve\<C-g>"
endfunction
" autocmd FileType markdown let g:PasteImageFunction = 'g:MarkdownPasteImage'
autocmd FileType tex let g:PasteImageFunction = 'g:LatexPasteImage'
autocmd FileType markdown,tex nmap <buffer><silent> <leader>pi :call mdip#MarkdownClipboardImage()<CR>

if has('nvim') || v:version >= 802
	let g:quickui_color_scheme = 'system'
	let g:quickui_context = [['hello', 'echo "hello world!"']]
	let g:quickui_border_style = 2

	"""""""""""""""""" floaterm
	" The popup window always has focus, it is not possible to switch to another window.
	" See *popup-terminal*
	let g:floaterm_opener = 'vsplit'
	let g:floaterm_width = 0.95
	let g:floaterm_height = 0.95
	let g:floaterm_position = 'right'
	let g:floaterm_rootmarkers = g:RootMarks
	" imap中F12被映射为UltiSnipsExpandTrigger, see plugin.vim
	let g:floaterm_keymap_toggle = '<F2>'
	let g:floaterm_title='<F9> kill | <F10> new | <F11> prev | <F12> next | <F2> toggle ($1/$2)'
	" 在floaterm中才会生效的快捷键
	augroup FloatermShortcuts
		autocmd!
		autocmd FileType floaterm tnoremap <buffer> <F9>  <C-\><C-n>:FloatermKill<CR>
		autocmd FileType floaterm tnoremap <buffer> <F10>  <C-\><C-n>:FloatermNew<CR>
		autocmd FileType floaterm tnoremap <buffer> <F11> <C-\><C-n>:FloatermPrev<CR>
		autocmd FileType floaterm tnoremap <buffer> <F12> <C-\><C-n>:FloatermNext<CR>
	augroup END
	" 使用Fern作为内置文件浏览器，不添加 :Yazi, :NNN, :Vifm等命令
	""""""""""""""""""

	let g:pydocstring_doq_path = 'doq'
	let g:pydocstring_formatter = 'numpy'

	let g:jupyter_mapkeys = 0
	let g:jupyter_cell_separators = ['\s*##']

	let g:jupyter_ascending_default_mappings = 0
	let g:jupyter_ascending_python_executable = 'python3'
	" 同步到浏览器内存中，若要同步到.ipynb文件中，需要浏览器手动/自动定时保存
	" 或执行 jupytext --to ipynb hello2.sync.py，(虽然会丢失执行结果)
	let g:jupyter_ascending_auto_write = v:true

	let g:jupytext_fmt = 'py'

	" ocaml utop在第一次send时可能会失败，需要再send一次，或提前打开:SlimeConfig
	if has('nvim')
		let g:slime_target = "tmux"
		" g:slime_bracketed_paste = 0 slime多行复制粘贴有问题
		let g:slime_bracketed_paste = 1
	else
		let g:slime_target = "vimterminal"
	endif
	let g:slime_no_mappings = 1

	function s:map_sender(sender)
		if a:sender == 'slime'
			xmap <leader>sp <Plug>SlimeRegionSend
			nmap <leader>sl <Plug>SlimeLineSend
			nmap <leader>sp <Plug>SlimeParagraphSend
			nmap <leader>sc <Plug>SlimeSendCell
		elseif a:sender == 'jupyter' || a:sender == 'jupyter-matplotlib'
			:JupyterConnect
			nnoremap <leader>sc :JupyterSendCell<CR>
			nnoremap <leader>si :JupyterSendCode ''<Left>
			nnoremap <leader>sp :JupyterSendRange<CR>
			xnoremap <leader>sp :JupyterSendRange<CR>
			if a:sender == 'jupyter-matplotlib'
				let timer = timer_start(1500, function('jupyter_custom#MatplotlibInit'))
			endif
		endif
	endfunction
	function s:sender_list(ArgLead, CmdLine, CursorPos)
		return filter(['jupyter', 'jupyter-matplotlib', 'slime'], 'stridx(v:val, a:ArgLead) == 0')
	endfunction
	command -nargs=1 -complete=customlist,s:sender_list MapSender call s:map_sender(<f-args>)
	MapSender slime
endif
if !empty($USE_VIM_MERGETOOL)
	autocmd BufEnter * if get(g:, 'mergetool_in_merge_mode', 0) | :GitGutterBufferDisable | endif
endif

" 默认主题不要显示colorcolumn
set colorcolumn=80,120
if !has('patch-9.1.176') || !has('nvim')
	" markdown会conceal一些字符，导致colorcolumn显示混乱
	autocmd FileType org,markdown,text setlocal colorcolumn=
endif
