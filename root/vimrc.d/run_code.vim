autocmd FileType c :command! -nargs=0 RunCode :!cc % -o %:r && ./%:r
autocmd FileType cpp :command! -nargs=0 RunCode :!c++ % -o %:r && ./%:r
autocmd FileType python :command! -nargs=0 RunCode :!python3 %

nnoremap <Leader>rc :RunCode<CR>

" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,java,scala 	                   let b:comment_leader = '// '
  autocmd FileType sh,ruby,python,conf,fstab,gitconfig   let b:comment_leader = '# '
  autocmd FileType tex                                   let b:comment_leader = '% '
  autocmd FileType mail                                  let b:comment_leader = '> '
  autocmd FileType vim                                   let b:comment_leader = '" '
augroup END

" a sed (s/what/towhat/where) command changing ^ (start of line) to the correctly set comment character based on the type of file you have opened 
" as for the silent thingies they just suppress output from commands. 
" :nohlsearch stops it from highlighting the sed search
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
