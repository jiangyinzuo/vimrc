" support more features(mermaid, flowchart, ...)
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install', 'for': 'markdown' }

" See: https://github.com/preservim/vim-markdown/pull/633
Plug 'jiangyinzuo/vim-markdown', { 'for': 'markdown' }

let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1

if (has('unix') && exists('$WSLENV'))
	command! -nargs=0 MdPreview call wsl#MdPreview()
endif

