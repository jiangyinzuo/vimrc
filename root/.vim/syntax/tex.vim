" 将注释中的 note 识别为 TODO， 忽略大小写
" See Also: :h vimtex.txt
syntax case ignore
syntax keyword texCommentTodo note
			\ containedin=texComment contained
