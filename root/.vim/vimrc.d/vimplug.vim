" run
" :source %
" to update
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(g:vim_plug_dir)

" similar Plugin: Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'matze/vim-move'

Plug 'andymass/vim-matchup'
" Test framework
" Plug 'junegunn/vader.vim'

" Test wrapper
Plug 'vim-test/vim-test'

" Plug 'mbbill/undotree'
" let g:undotree_WindowLayout = 4
Plug 'simnalamburt/vim-mundo'

" suda is a plugin to read or write files with sudo command.
Plug 'lambdalisue/vim-suda'
Plug 'aperezdc/vim-template'

Plug 'szw/vim-maximizer'
Plug 'wesQ3/vim-windowswap'
Plug 'tyru/capture.vim'

" enhanced ga(show not only ascii code, but also unicode code, emoji,
" digraphs, etc.)
" See Also: :h :ascii
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-speeddating'
Plug 'jiangyinzuo/bd.vim'

" vim-surround和vim-sneak会共享s/S shortcut，但不冲突
" 创建surround类文本对象
Plug 'tpope/vim-surround'
" Vim sugar for the UNIX shell commands that need it the most
Plug 'tpope/vim-eunuch'
" 针对某些编程语言，快速分开/合并语句, 改进原生的gJ
Plug 'AndrewRadev/splitjoin.vim'
" 改进查找替换
Plug 'tpope/vim-abolish'
" Plug 'arthurxavierx/vim-caser' " use vim-abolish cr

Plug 'preservim/tagbar'
" See: https://github.com/liuchengxu/vista.vim/issues/462
Plug 'liuchengxu/vista.vim'
Plug 'samoshkin/vim-mergetool'

Plug 'godlygeek/tabular'
Plug 'axvr/org.vim', { 'for': 'org' }
" The full plugin has :TypstWatch, :Toc commands while built-in has not.
Plug 'kaarmu/typst.vim', { 'for': 'typst' }

Plug 'inkarkat/vim-ingo-library' " dependency of vim-AdvancedSorters
Plug 'inkarkat/vim-AdvancedSorters'

" Plug 'nordtheme/vim', { 'as': 'nordtheme' }
" Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'tomasiser/vim-code-dark'
" Plug 'morhetz/gruvbox'

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
if has('patch-9.1.375')
	packadd comment
else
	Plug 'tpope/vim-commentary'
endif
Plug 'tpope/vim-endwise'

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

Plug 'dhruvasagar/vim-table-mode'
if v:version >= 800
	Plug 'brooth/far.vim', {'on': ['Far', 'Farf', 'Farp', 'Farr']}
	Plug 'preservim/vimux'
	Plug 'SirVer/ultisnips'
	Plug 'honza/vim-snippets'
	Plug 'voldikss/vim-translator'

	Plug 'mechatroner/rainbow_csv', { 'for': 'csv' }

	" Alternative: https://github.com/sindrets/diffview.nvim
	Plug 'jiangyinzuo/open-gitdiff.vim'
	Plug 'andrewradev/linediff.vim'

	Plug 'lifepillar/vim-solarized8'
	source ~/.vim/vimrc.d/leaderf.vim

	if v:version >= 801
		Plug 'ap/vim-css-color'
		Plug 'LunarWatcher/auto-pairs'

		" See: https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
		" fix conflict with autopairs
		Plug 'jiangyinzuo/vim-visual-multi', {'branch': 'master'}
		if v:version >= 802
			" neovim 内置了 inccommand, 无需该插件
			Plug 'markonm/traces.vim'
			" Alternative? https://github.com/jasonccox/vim-wayland-clipboard
			" See:
			" https://github.com/vim/vim/pull/9639
			" https://github.com/vim/vim/releases/tag/v9.1.0064
			Plug 'ojroques/vim-oscyank', {'branch': 'main'}

			Plug 'skywind3000/vim-quickui'
			Plug 'pechorin/any-jump.vim'

			Plug 'voldikss/vim-floaterm'
			Plug 'voldikss/LeaderF-floaterm'
			Plug 'voldikss/fzf-floaterm'
			Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
			Plug 'junegunn/fzf.vim'
			Plug 'jiangyinzuo/z.vim'
			source ~/.vim/vimrc.d/fzf.vim

			Plug 'lambdalisue/vim-fern'
			Plug 'lambdalisue/nerdfont.vim'
			Plug 'lambdalisue/fern-renderer-nerdfont.vim'
			Plug 'lambdalisue/fern-hijack.vim'
			Plug 'LumaKernel/fern-mapping-fzf.vim'

			" require +job
			" pip3 install doq --break-system-packages
			Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }

			Plug 'jpalardy/vim-slime', {'for': ['lua', 'python', 'ocaml']}

			" support more features(mermaid, flowchart, ...)
			Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install', 'for': ['markdown', 'quarto'] }

			" See: https://github.com/preservim/vim-markdown/pull/633
			Plug 'jiangyinzuo/vim-markdown', { 'for': 'markdown' }

			Plug 'skywind3000/asynctasks.vim'
			Plug 'skywind3000/asyncrun.vim'
			source ~/.vim/vimrc.d/asynctasks.vim

			if v:version >= 900
				" Use release branch (recommend)
				Plug 'neoclide/coc.nvim', {'branch': 'release'}
				Plug 'antoinemadec/coc-fzf'
				Plug 'Clavelito/indent-awk.vim'
				Plug 'bfrg/vim-qf-preview'
				Plug 'Eliot00/git-lens.vim'
				let g:GIT_LENS_ENABLED = 0

				if v:version >= 901
					Plug 'girishji/devdocs.vim', {'on': ['DevdocsFind', 'DevdocsInstrall', 'DevdocsUninstall', 'DevdocsTagStack']}
					" Alternative: https://github.com/gelguy/wilder.nvim
					Plug 'girishji/vimsuggest'
					autocmd VimEnter * ++once if exists('*g:VimSuggestSetOptions') | call g:VimSuggestSetOptions({ 'cmd': { 'exclude': ['!', '^Git\s', '^Floaterm', '^Far', '^Man'] }}) | endif
					" 直接vim paper.tex打开文件时，需要手动:e 重新打开一次，才能加载vimtex的syntax
					" do not lazy load vimtex
					Plug 'lervag/vimtex'
					source ~/.vim/vimrc.d/latex.vim
				endif
			endif
			if g:vim_dap == 'vimspector'
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
			" Plug 'jiangyinzuo/term-debugger'
		endif
	endif
endif

Plug 'airblade/vim-gitgutter'
" 比默认priority低1级
let g:gitgutter_sign_priority = 9
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" FZF :Commits依赖vim-fugitive
Plug 'tpope/vim-fugitive'
" A git commit browser.
Plug 'junegunn/gv.vim'
" optionally depend on vim-fugitive
Plug 'jiangyinzuo/codenote'

source ~/.vim/vimrc.d/ai.vim
Plug 'bfrg/vim-cpp-modern', {'for': ['c', 'cpp']}
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
" Alternative: HakonHarnes/img-clip.nvim
Plug 'jiangyinzuo/img-paste.vim'
Plug 'whonore/Coqtail', { 'for': 'coq' }

" if exists("$WSLENV")
" 	" https://github.com/alacritty/alacritty/issues/2324#issuecomment-1339594232
" 	inoremap <C-v> <ESC>:silent r!pbpaste<CR>'.kJ
" endif

source ~/.vim/vimrc.d/plugin_setup.vim
" Initialize plugin system
call plug#end()

if g:no_plug
	finish
endif

source ~/.vim/vimrc.d/slime.vim

"""""""""""""""""" begin colorscheme
" 防止neovim启动时屏幕暂时变成黑色
if has("termguicolors") && ($COLORTERM == 'truecolor' || g:vimrc_use_true_color)
	set termguicolors
endif

let g:nord_uniform_diff_background = 1
let g:dracula_high_contrast_diff = 1
" 防止neovim启动时屏幕暂时变成黑色
if v:version >= 800
	" true color support
	" https://github.com/lifepillar/vim-solarized8#troubleshooting
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	let g:solarized_diffmode = "normal"
	colorscheme solarized8
	hi NonText cterm=None term=None gui=None
	" solarized8会覆盖debugPC和debugBreakpoint的颜色，需要重新设置
	hi debugPC term=reverse ctermbg=darkblue guibg=darkblue
	hi debugBreakpoint term=reverse ctermbg=red guibg=red
endif

" tab颜色
hi clear SpecialKey
hi link SpecialKey NonText
"hi SpecialKey ctermfg=darkgray guifg=#5a5a5a
hi link QuickPreview Normal
"""""""""""""""""" end colorscheme

if v:version >= 801
	if v:version >= 900 && g:vimrc_lsp == 'coc.nvim'
		source ~/.vim/vimrc.d/coc.vim
	endif
	let g:AutoPairs = autopairs#AutoPairsDefine([
				\ {"open": "<", "close": ">", "filetype": ["html"]}
				\ ]) " This is a filetype-specific mapping
	let g:AutoPairsLanguagePairs['vifm'] = g:AutoPairsLanguagePairs['vim']
endif
