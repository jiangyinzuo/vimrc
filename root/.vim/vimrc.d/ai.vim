if has('python3')
	Plug 'madox2/vim-ai'
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
endif
