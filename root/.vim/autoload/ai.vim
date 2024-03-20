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
function ai#GitCommitMessage()
  let l:diff = system('git --no-pager diff --staged')
  let l:prompt = "generate a short git commit message from the diff below, using conventional commit format:\n" . l:diff
  let l:config = {
  \  "engine": "chat",
  \  "options": {
  \    "endpoint_url": g:vim_ai_endpoint_url,
  \    "model": g:vim_ai_model,
  \    "initial_prompt": ">>> system\nyou are a code assistant",
  \    "temperature": 1,
  \  },
  \}
  call vim_ai#AIRun(l:config, l:prompt)
endfunction
