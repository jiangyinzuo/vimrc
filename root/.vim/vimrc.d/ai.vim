if has('nvim') || v:version >= 900
	" alternatives: https://github.com/codota/tabnine-nvim
	if g:ai_complete == 'copilot'
		" copilot.vim在打开文件后，第一次快速进入插入模式时，存在卡顿的问题
		" Github Coplit Support
		" https://docs.github.com/en/copilot/getting-started-with-github-copilot/getting-started-with-github-copilot-in-neovim?platform=linux
		Plug 'github/copilot.vim'
		" use <C-x> to auto complete github copilot
		" imap <silent><script><expr> <C-x> copilot#Accept("\<CR>")
		" let g:copilot_no_tab_map = v:true

		" Load the plugin on InsertEnter
		" autocmd InsertEnter * ++once call plug#load('copilot.vim')

		" showkey -a 查看组合键的编码
		" M-c M-[ 存在bug
		" 在终端下按下 ALT+X，那么终端软件将会发送 <ESC>x 两个字节过去，字节码为：0x27, 0x78。
		" See Also:
		" https://superuser.com/questions/1554782/why-was-the-meta-key-replaced-on-modern-terminals
		" https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
		" https://www.skywind.me/blog/archives/2021
		" :h set-termcap
		execute "set <M-n>=\en"
		execute "set <M-p>=\ep"
		execute "set <M-x>=\ex"
		execute "set <M-w>=\ew"
		execute "set <M-l>=\el"
		imap <M-p> <Plug>(copilot-previous)
		imap <M-n> <Plug>(copilot-next)
		imap <M-x> <Plug>(copilot-dismiss)
		imap <M-w> <Plug>(copilot-accept-word)
		imap <M-l> <Plug>(copilot-accept-line)
		imap <M-s> <Plug>(copilot-suggest)

	elseif g:ai_complete == 'codeium'
		Plug 'Exafunction/codeium.vim'
		let g:codeium_disable_bindings = 1
		execute "set <M-n>=\en"
		execute "set <M-p>=\ep"
		execute "set <M-x>=\ex"
		imap <script><silent><nowait><expr> <Tab> codeium#Accept()
		imap <M-p> <Plug>(codeium-previous)
		imap <M-n> <Plug>(codeium-next)
		imap <M-x> <Plug>(codeium-dismiss)
	endif
endif

if has('python3')
	Plug 'madox2/vim-ai', { 'do': 'sed -i \"s/api.openai.com/api.aiproxy.io/g\" py/chat.py py/complete.py ' }
	let g:vim_ai_chat = {
				\  "options": {
				\    "model": "gpt-4",
				\    "max_tokens": 1000,
				\    "temperature": 1,
				\    "request_timeout": 20,
				\    "selection_boundary": "",
				\    "initial_prompt": "",
				\  },
				\  "ui": {
				\    "code_syntax_enabled": 1,
				\    "populate_options": 0,
				\    "open_chat_command": "preset_below",
				\    "scratch_buffer_keep_open": 0,
				\    "paste_mode": 1,
				\  },
				\}

	let g:vim_ai_edit = {
				\  "engine": "chat",
				\  "options": {
				\    "model": "gpt-4",
				\    "max_tokens": 1000,
				\    "temperature": 1,
				\    "request_timeout": 20,
				\    "selection_boundary": "",
				\  },
				\  "ui": {
				\    "paste_mode": 1,
				\  },
				\}

	let g:vim_ai_complete = g:vim_ai_edit

	function AIRunWithInitialPrompt(func, prompt, range, ...) range
		let l:config = {
					\  "options": {
					\    "initial_prompt": ">>> system\n" . a:prompt,
					\  },
					\}
		let l:prompt = a:0 ? a:1 : ''
		call call(a:func, [a:range, l:config, l:prompt])
	endfunction
	command! -range -nargs=? AITranslate <line1>,<line2>call AIRunWithInitialPrompt(function('vim_ai#AIChatRun'), "中英互译：", <range>, <f-args>)
	command! -range -nargs=? AIPolish <line1>,<line2>call AIRunWithInitialPrompt(function('vim_ai#AIEditRun'), "英文润色：", <range>, <f-args>)
endif
