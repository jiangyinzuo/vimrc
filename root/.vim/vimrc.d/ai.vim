if v:version >= 900 || has('nvim')
	let g:vim_ai_roles_config_file = '~/.vim/vim-ai-roles.ini'

	" alternatives: https://github.com/codota/tabnine-nvim
	if g:ai_suggestion == 'copilot.vim'
		" copilot.vim在打开文件后，第一次快速进入插入模式时，存在卡顿的问题
		" Github Coplit Support
		" https://docs.github.com/en/copilot/getting-started-with-github-copilot/getting-started-with-github-copilot-in-neovim?platform=linux
		if !has('nvim')
			Plug 'github/copilot.vim'
		endif
		" use <C-x> to auto complete github copilot
		" imap <silent><script><expr> <C-x> copilot#Accept("\<CR>")
		" let g:copilot_no_tab_map = v:true

		" Load the plugin on InsertEnter
		" autocmd InsertEnter * ++once call plug#load('copilot.vim')
		imap <M-p> <Plug>(copilot-previous)
		imap <M-n> <Plug>(copilot-next)
		imap <M-x> <Plug>(copilot-dismiss)
		imap <M-w> <Plug>(copilot-accept-word)
		imap <M-l> <Plug>(copilot-accept-line)
		imap <M-s> <Plug>(copilot-suggest)
		" copilot workspace folder
		autocmd BufReadPost,BufNewFile * ++once let b:workspace_folder = asyncrun#current_root()

	elseif g:ai_suggestion == 'codeium.vim'
		" Alternative: https://github.com/Exafunction/codeium.nvim
		if !has('nvim')
			Plug 'Exafunction/codeium.vim'
		endif
		let g:codeium_disable_bindings = 1
		command -nargs=0 CodeiumChat call codeium#Chat()
		if g:no_plug == 0
			imap <script><silent><nowait><expr> <Tab> codeium#Accept()
			imap <M-p> <Plug>(codeium-previous)
			imap <M-n> <Plug>(codeium-next)
			imap <M-x> <Plug>(codeium-dismiss)
		endif
	elseif g:ai_suggestion == 'fittencode'
		if !has('nvim')
			Plug 'FittenTech/fittencode.vim'
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

	if !has('nvim')
		Plug 'madox2/vim-ai'
	endif
	call AISwitchServer(get(g:, 'ai_service', 'aiproxy'))
	command! -range -nargs=? AITranslate <line1>,<line2>call vim_ai#AIChatRun(<range>, ai#CreateInitialPrompt("中英互译："), <f-args>)
	command! -range -nargs=? AIPolish <line1>,<line2>call vim_ai#AIEditRun(ai#CreateInitialPrompt("英文润色："), <f-args>)
endif
