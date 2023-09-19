if has('nvim') || v:version >= 900
	" Github Coplit Support
	" https://docs.github.com/en/copilot/getting-started-with-github-copilot/getting-started-with-github-copilot-in-neovim?platform=linux
	Plug 'github/copilot.vim'
	" use <C-x> to auto complete github copilot
	" imap <silent><script><expr> <C-x> copilot#Accept("\<CR>")
	" let g:copilot_no_tab_map = v:true
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
