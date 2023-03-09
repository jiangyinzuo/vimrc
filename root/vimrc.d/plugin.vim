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
call plug#begin('~/.vim/plugged')

Plug 'nvim-treesitter/nvim-treesitter', Cond(has('nvim'), {'do': ':TSUpdate'})

" Plug 'LunarWatcher/auto-pairs'
" let g:AutoPairsMapBS = 1

" similar Plugin: Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#s_next = 1
" default s: delete [count] charaters and start insert
map s <Plug>Sneak_s
map S <Plug>Sneak_S
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

Plug 'markonm/traces.vim'
if has("nvim")
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
else
	Plug 'tomasiser/vim-code-dark'
end

Plug 'voldikss/vim-floaterm'
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8

" Plug 'MattesGroeger/vim-bookmarks'

" Plug 'ojroques/vim-oscyank', {'branch': 'main'}
" vnoremap <leader>c :OSCYank<CR>

Plug 'airblade/vim-gitgutter'

" executable() is slow
source ~/vimrc.d/leaderf.vim
source ~/vimrc.d/fzf.vim
source ~/vimrc.d/coc.vim
source ~/vimrc.d/cpp.vim
" source ~/vimrc.d/go.vim
source ~/vimrc.d/markdown.vim
source ~/vimrc.d/latex.vim

Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

Plug 'honza/vim-snippets'

source ~/vimrc.d/asynctasks.vim

" Initialize plugin system
call plug#end()

if has("nvim")
	" colorscheme tokyonight-storm
else
	colorscheme codedark
end
