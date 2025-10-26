function ai#CreateInitialPrompt(prompt)
	let l:config = {
				\  "options": {
				\    "initial_prompt": ">>> system\n" . a:prompt,
				\  },
				\}
	return l:config
endfunction

function ai#RunWithInitialPrompt(func, prompt, range, ...) range
	let l:config = {
				\  "options": {
				\    "initial_prompt": ">>> system\n" . a:prompt,
				\  },
				\}
	let l:prompt = a:0 ? a:1 : ''
	call call(a:func, [a:range, l:config, l:prompt])
endfunction
function ai#GitCommitMessage(diffmsg)
	let l:range = 0
	let l:prompt = g:ai_git_commit_message_prompt . "\nThe following are `git diff` output:\n" . a:diffmsg
	let l:config = {
				\  "engine": "chat",
				\  "options": {
				\    "endpoint_url": g:openai_endpoint . "/chat/completions",
				\    "model": g:openai_model,
				\    "initial_prompt": ">>> system\nyou are a code assistant",
				\    "temperature": 0.2,
				\  },
				\}
	call vim_ai#AIRun(l:range, l:config, l:prompt)
endfunction
