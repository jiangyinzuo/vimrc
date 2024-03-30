if has('nvim') || v:version >= 900
	let g:vim_ai_roles_config_file = '~/.vim/vim-ai-roles.ini'

	" alternatives: https://github.com/codota/tabnine-nvim
	if g:ai_complete == 'copilot'
		" copilot.vim在打开文件后，第一次快速进入插入模式时，存在卡顿的问题
		" Github Coplit Support
		" https://docs.github.com/en/copilot/getting-started-with-github-copilot/getting-started-with-github-copilot-in-neovim?platform=linux
		if g:vim_package_manager == 'vim-plug'
			Plug 'github/copilot.vim'
		endif
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
		" Alternative: https://github.com/Exafunction/codeium.nvim
		if g:vim_package_manager == 'vim-plug'
			Plug 'Exafunction/codeium.vim'
		endif
		let g:codeium_disable_bindings = 1
		command -nargs=0 CodeiumChat call codeium#Chat()
		execute "set <M-n>=\en"
		execute "set <M-p>=\ep"
		execute "set <M-x>=\ex"
		if g:no_plug == 0
			imap <script><silent><nowait><expr> <Tab> codeium#Accept()
			imap <M-p> <Plug>(codeium-previous)
			imap <M-n> <Plug>(codeium-next)
			imap <M-x> <Plug>(codeium-dismiss)
		endif
	elseif g:ai_complete == 'fittencode'
		if g:vim_package_manager == 'vim-plug'
			if has('nvim')
				Plug 'luozhiya/fittencode.nvim'
			else
				Plug 'FittenTech/fittencode.vim'
			endif
		endif
	endif
endif

if has('python3')
	" 01ai: https://platform.lingyiwanwu.com/docs
	let s:backend_dict = {
				\ 'aiproxy': {'url': get(g:, 'openai_proxy_url', 'https://api.aiproxy.io/v1/chat/completions'), 'model': 'gpt-4', 'token_file': '~/.config/openai.token'},
				\ 'kimichat': {'url': 'https://api.moonshot.cn/v1/chat/completions', 'model': 'moonshot-v1-8k', 'token_file': '~/.config/kimichat.token'},
				\ '01ai': {'url': 'https://api.lingyiwanwu.com/v1/chat/completions', 'model': 'yi-34b-chat-0205', 'token_file': '~/.config/01ai.token'},
				\ }
	function AISwitchServer(backend)
		let g:vim_ai_endpoint_url = s:backend_dict[a:backend]['url']
		let g:vim_ai_token_file_path = s:backend_dict[a:backend]['token_file']
		let g:vim_ai_model = s:backend_dict[a:backend]['model']
		" temperature越高，生成的文本越随机。chatgpt默认temperature值为0.7
		let g:vim_ai_chat = {
					\  "options": {
					\    "endpoint_url": g:vim_ai_endpoint_url,
					\    "model": g:vim_ai_model,
					\    "max_tokens": 1000,
					\    "temperature": 0.7,
					\    "request_timeout": 20,
					\    "selection_boundary": "",
					\    "enable_auth": 1,
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
					\    "endpoint_url": g:vim_ai_endpoint_url,
					\    "model": g:vim_ai_model,
					\    "max_tokens": 1000,
					\    "temperature": 0.2,
					\    "request_timeout": 20,
					\    "enable_auth": 1,
					\    "selection_boundary": "",
					\  },
					\  "ui": {
					\    "paste_mode": 1,
					\  },
					\}
		let g:vim_ai_complete = g:vim_ai_edit
	endfunction
	function AISwitchServerComplete(A, L, P)
		return keys(s:backend_dict)
	endfunction

	command -nargs=1 -complete=customlist,AISwitchServerComplete AISwitchServer call AISwitchServer(<f-args>) | echom g:vim_ai_endpoint_url . ' ' . g:vim_ai_token_file_path . ' ' . g:vim_ai_model

	if g:vim_package_manager == 'vim-plug'
		Plug 'madox2/vim-ai'
	endif
	call AISwitchServer(get(g:, 'ai_service', 'aiproxy'))
	command! -range -nargs=? AITranslate <line1>,<line2>call vim_ai#AIChatRun(<range>, ai#CreateInitialPrompt("中英互译："), <f-args>)
	command! -range -nargs=? AIPolish <line1>,<line2>call vim_ai#AIEditRun(ai#CreateInitialPrompt("英文润色："), <f-args>)
endif
