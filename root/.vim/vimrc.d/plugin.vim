function Cond(cond, ...)
	let opts = get(a:000, 0, {})
	return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" run
" :source %
" to update
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(g:vim_plug_dir)

" similar Plugin: Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'

if has('nvim') || v:version >= 801
	Plug 'ap/vim-css-color'
	Plug 'LunarWatcher/auto-pairs'
	Plug 'markonm/traces.vim'

	" fix conflict with autopairs
	Plug 'jiangyinzuo/vim-visual-multi', {'branch': 'master'}
endif

if !exists('g:vscode')
	" Test framework
	" Plug 'junegunn/vader.vim'

	" Test wrapper
	Plug 'vim-test/vim-test'

	" Plug 'mbbill/undotree'
	" let g:undotree_WindowLayout = 4
	Plug 'simnalamburt/vim-mundo'
	" Enable persistent undo so that undo history persists across vim sessions

	Plug 'aperezdc/vim-template'
	
	Plug 'szw/vim-maximizer'

	" Commenting blocks of code.
	" 可以选中多行后，用:norm i# 在所有行前面添加#
	" :norm 0i 在所有行前面添加
	" :norm ^i 在所有行前面添加(不包括空格)
	" :norm 0x删除所有行的第一个字母
	" :norm ^x删除所有行的第一个字母(不包括空格)
	"
	" Replace custom commands for commenting.
	" Since: v0.12.0
	" See Also: https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim
	Plug 'tpope/vim-commentary'

	" enhanced ga(show not only ascii code, but also unicode code, emoji,
	" digraphs, etc.)
	" See Also: :h :ascii
	Plug 'tpope/vim-characterize'

	if has('nvim') || v:version >= 800
		Plug 'brooth/far.vim', {'on': ['Far', 'Farf', 'Farp', 'Farr']}
		Plug 'preservim/vimux'
		Plug 'SirVer/ultisnips'
		" 大多数情况下使用coc-ultisnips的回车键补全，若遇到tb23
		" 这样的补全，使用F12
		" nmap中F12被映射为打开终端, see floaterm.vim
		let g:UltiSnipsExpandTrigger="<f12>"

		Plug 'honza/vim-snippets'
		Plug 'voldikss/vim-translator'
		Plug 'romainl/vim-qf'

		Plug 'mechatroner/rainbow_csv', { 'for': 'csv' }

		" Alternative: https://github.com/sindrets/diffview.nvim
		Plug 'jiangyinzuo/open-gitdiff.vim'
	endif

	" vim-surround和vim-sneak会共享s/S shortcut，但不冲突
	" 创建surround类文本对象
	Plug 'tpope/vim-surround'
	" Vim sugar for the UNIX shell commands that need it the most
	Plug 'tpope/vim-eunuch'
	" 针对某些编程语言，快速分开/合并语句, 改进原生的gJ
	Plug 'AndrewRadev/splitjoin.vim'
	" 改进查找替换
	Plug 'tpope/vim-abolish'
	Plug 'arthurxavierx/vim-caser'

	Plug 'preservim/tagbar'
	" See: https://github.com/liuchengxu/vista.vim/issues/462
	Plug 'liuchengxu/vista.vim'
	Plug 'samoshkin/vim-mergetool'

	Plug 'godlygeek/tabular'
	Plug 'axvr/org.vim', { 'for': 'org' }
	Plug 'kaarmu/typst.vim', { 'for': 'typst' }
	if (v:version >= 802 || has('nvim')) && g:vimrc_lsp == 'coc.nvim'
		" Use release branch (recommend)
		Plug 'neoclide/coc.nvim', {'branch': 'release'}
		Plug 'antoinemadec/coc-fzf'
	endif
	if has('nvim')
		source ~/.vim/vimrc.d/plugin_nvim.vim
	else
		" Plug 'nordtheme/vim', { 'as': 'nordtheme' }
		" Plug 'dracula/vim', { 'as': 'dracula' }
		" Plug 'tomasiser/vim-code-dark'
		" Plug 'morhetz/gruvbox'

		" Remove ~/.vim/autoload/detect_indent.vim
		" Since: v0.12.0
		if v:version >= 901
			packadd! editorconfig
		else
			Plug 'editorconfig/editorconfig-vim'
		endif
		let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'gitdiff://.*', 'scp://.*']
		au FileType gitcommit let b:EditorConfig_disable = 1
		" vim-sleuth does not behave as expected.
		" Plug 'tpope/vim-sleuth'

		if v:version >= 800
			Plug 'lifepillar/vim-solarized8'
			source ~/.vim/vimrc.d/leaderf.vim
			if v:version >= 802
				if v:version >= 900
					" Alternative: https://github.com/gelguy/wilder.nvim
					Plug 'girishji/autosuggest.vim'
					" External cmd is slow.
					autocmd VimEnter * ++once if exists('*g:AutoSuggestSetup') | call g:AutoSuggestSetup({ 'cmd': { 'exclude': ['!', '^Git\s'] }}) | endif
					if v:version >= 901
						Plug 'girishji/devdocs.vim', {'on': ['DevdocsFind', 'DevdocsInstrall', 'DevdocsUninstall', 'DevdocsTagStack']}
					endif
				endif
				if g:vimrc_use_vimspector
					Plug 'puremourning/vimspector'
					let g:vimspector_enable_mappings='VISUAL_STUDIO'

					" See: https://puremourning.github.io/vimspector/configuration.html#configuration-format
					" There are two locations for debug configurations for a project:
					" 
					" g:vimspector_configurations vim variable (dict)
					" <vimspector home>/configurations/<OS>/<filetype>/*.json
					" .vimspector.json in the project source
					"
					" json配置位于.vim/configurationsw目录下
					let g:vimspector_base_dir = $HOME . '/.vim'
					let g:vimspector_sign_priority = {
								\    'vimspectorBP':          20,
								\    'vimspectorBPCond':      20,
								\    'vimspectorBPLog':       20,
								\    'vimspectorBPDisabled':  20,
								\    'vimspectorNonActivePC': 20,
								\    'vimspectorPC':          999,
								\    'vimspectorPCBP':        999,
								\ }
				endif
				Plug 'jiangyinzuo/term-debugger'
			endif
		endif
	endif

	Plug 'airblade/vim-gitgutter'
	" FZF :Commits依赖vim-fugitive
	Plug 'tpope/vim-fugitive'
	" A git commit browser.
	Plug 'junegunn/gv.vim'
	if has('vim9script')
		Plug 'Clavelito/indent-awk.vim'
		Plug 'Eliot00/git-lens.vim'
		let g:GIT_LENS_ENABLED = 0
	endif

	" Plug 'MattesGroeger/vim-bookmarks'
	source ~/.vim/vimrc.d/ai.vim
	Plug 'bfrg/vim-cpp-modern', {'for': ['c', 'cpp', 'cuda']}
	" Enable function highlighting (affects both C and C++ files)
	let g:cpp_function_highlight = 1
	" Enable highlighting of C++11 attributes
	let g:cpp_attributes_highlight = 1
	" Highlight struct/class member variables (affects both C and C++ files)
	let g:cpp_member_highlight = 1
	" Put all standard C and C++ keywords under Vim's highlight group 'Statement' (affects both C and C++ files)
	let g:cpp_simple_highlight = 1
	source ~/.vim/vimrc.d/golang.vim

	Plug 'alepez/vim-gtest', {'for': ['c', 'cpp', 'cuda']}
	Plug 'lambdalisue/doctest.vim', {'for': 'python'}
	augroup doctest
		autocmd! *
			autocmd QuickFixCmdPost lDoctest nested lwindow
	augroup END

	" paste img in markdown/latex style
	Plug 'jiangyinzuo/img-paste.vim'
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
		Plug 'skywind3000/vim-quickui'
		let g:quickui_color_scheme = 'system'
		let g:quickui_context = [['hello', 'echo "hello world!"']]
		let g:quickui_border_style = 2
		Plug 'pechorin/any-jump.vim'
		" Alternative? https://github.com/jasonccox/vim-wayland-clipboard
		" See:
		" https://github.com/vim/vim/pull/9639
		" https://github.com/vim/vim/releases/tag/v9.1.0064
		Plug 'ojroques/vim-oscyank', {'branch': 'main'}
		" vnoremap <leader>c :OSCYank<CR>
	
		Plug 'voldikss/vim-floaterm'
		Plug 'voldikss/LeaderF-floaterm'
		Plug 'voldikss/fzf-floaterm'
		source ~/.vim/vimrc.d/floaterm.vim
		Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
		Plug 'junegunn/fzf.vim'
		source ~/.vim/vimrc.d/fzf.vim

		" require +job
		Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
		let g:pydocstring_doq_path = 'doq'
		let g:pydocstring_formatter = 'numpy'

		" vim和jupyter notebook(运行在浏览器上)同步，
		" 需要安装jupyter_ascending, 目前不支持notebook 7
		" :h jupyter-notebook
		" See: https://github.com/imbue-ai/jupyter_ascending
		" See: https://alpha2phi.medium.com/jupyter-notebook-vim-neovim-c2d67d56d563#c0ed
		Plug 'imbue-ai/jupyter_ascending.vim', {'for': 'python'}
		let g:jupyter_ascending_default_mappings = 0
		let g:jupyter_ascending_python_executable = 'python3'
		" 同步到浏览器内存中，若要同步到.ipynb文件中，需要浏览器手动/自动定时保存
		" 或执行 jupytext --to ipynb hello2.sync.py，(虽然会丢失执行结果)
		let g:jupyter_ascending_auto_write = v:true
		
		" vim和jupyter console/qtconsole同步
		" :h jupyter-qtconsole
		Plug 'jupyter-vim/jupyter-vim', {'on': 'JupyterConnect'}
		let g:jupyter_mapkeys = 0
		let g:jupyter_cell_separators = ['\s*##']

		" ipynb打开时显示python
		Plug 'goerz/jupytext.vim'
		let g:jupytext_fmt = 'py'

		Plug 'jpalardy/vim-slime', {'for': ['python', 'ocaml']}
		" ocaml utop在第一次send时可能会失败，需要再send一次，或提前打开:SlimeConfig
		let g:slime_target = "vimterminal"
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
		source ~/.vim/vimrc.d/markdown.vim
		" 直接vim paper.tex打开文件时，需要手动:e 重新打开一次，才能加载vimtex的syntax
		
		Plug 'lervag/vimtex', {'for': 'tex'}
		source ~/.vim/vimrc.d/latex.vim
		Plug 'skywind3000/asynctasks.vim'
		Plug 'skywind3000/asyncrun.vim'
		source ~/.vim/vimrc.d/asynctasks.vim
	endif
	Plug 'whonore/Coqtail', { 'for': 'coq' }

	" if exists("$WSLENV")
	" 	" https://github.com/alacritty/alacritty/issues/2324#issuecomment-1339594232
	" 	inoremap <C-v> <ESC>:silent r!pbpaste<CR>'.kJ
	" endif

endif " !exists('g:vscode')

source ~/.vim/vimrc.d/plugin_setup.vim
" Initialize plugin system
call plug#end()

if g:no_plug
	finish
endif

"""""""""""""""""" begin colorscheme
" neovim 要在colorscheme前立刻设置colors，否则会导致neovim启动时屏幕暂时变成黑色
if has("termguicolors") && ($COLORTERM == 'truecolor' || g:vimrc_use_true_color)
	set termguicolors
endif

let g:nord_uniform_diff_background = 1
let g:dracula_high_contrast_diff = 1
if v:version >= 800
	" true color support
	" https://github.com/lifepillar/vim-solarized8#troubleshooting
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	let g:solarized_diffmode = "normal"
	if has('nvim')
		colorscheme solarized
	else
		colorscheme solarized8
	endif
	hi NonText cterm=None term=None gui=None
endif

" tab颜色
hi clear SpecialKey
hi link SpecialKey NonText
"hi SpecialKey ctermfg=darkgray guifg=#5a5a5a
hi debugPC term=reverse ctermbg=4 guibg=DarkBlue
hi debugBreakpoint term=reverse ctermbg=red guibg=red
"""""""""""""""""" end colorscheme

if (v:version >= 802 || has('nvim')) && g:vimrc_lsp == 'coc.nvim'
	source ~/.vim/vimrc.d/coc.vim
endif

if has('nvim') || v:version >= 801
	let g:AutoPairs = autopairs#AutoPairsDefine([
				\ {"open": "<", "close": ">", "filetype": ["html"]}
				\ ]) " This is a filetype-specific mapping
	let g:AutoPairsLanguagePairs['vifm'] = g:AutoPairsLanguagePairs['vim']
endif
