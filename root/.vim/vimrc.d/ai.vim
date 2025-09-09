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

	elseif g:ai_suggestion == 'windsurf.vim'
		if !has('nvim')
			Plug 'Exafunction/windsurf.vim'
		endif
		let g:codeium_disable_bindings = 1
		command -nargs=0 CodeiumChat call codeium#Chat()
		if g:no_vimplug == 0
			imap <script><silent><nowait><expr> <Tab> codeium#Accept()
			imap <M-p> <Plug>(codeium-previous)
			imap <M-n> <Plug>(codeium-next)
			imap <M-x> <Plug>(codeium-dismiss)
		endif
	elseif g:ai_suggestion == 'fittencode'
		if !has('nvim')
			Plug 'FittenTech/fittencode.vim'
		endif
	elseif g:ai_suggestion == 'augment.vim'
		if !has('nvim')
			Plug 'augmentcode/augment.vim'
		endif
	endif
endif

if has('python3')
	let g:vim_ai_chat = {
				\  "options": {
				\    "endpoint_url": g:openai_endpoint . "/chat/completions",
				\    "model": g:openai_model,
				\    "max_tokens": 1000,
				\    "temperature": 0.7,
				\    "request_timeout": 20,
				\    "selection_boundary": "",
				\    "enable_auth": 1,
				\    "token_file_path": g:openai_token_file,
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
				\    "endpoint_url": g:openai_endpoint . "/chat/completions",
				\    "model": g:openai_model,
				\    "max_tokens": 1000,
				\    "temperature": 0.2,
				\    "request_timeout": 20,
				\    "enable_auth": 1,
				\    "token_file_path": g:openai_token_file,
				\    "selection_boundary": "",
				\  },
				\  "ui": {
				\    "paste_mode": 1,
				\  },
				\}
	let g:vim_ai_complete = g:vim_ai_edit

	if !has('nvim')
		Plug 'madox2/vim-ai'
	endif
	command! -range -nargs=? AITranslate <line1>,<line2>call vim_ai#AIChatRun(<range>, ai#CreateInitialPrompt("中英互译："), <f-args>)
	command! -range -nargs=? AIPolish <line1>,<line2>call vim_ai#AIEditRun(ai#CreateInitialPrompt("英文润色："), <f-args>)
endif
