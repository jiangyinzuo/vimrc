--- 自动浮窗展示diagnostic
local function create_floating_window_autocmd()
	vim.api.nvim_create_augroup("nvim_lsp_floating_window", {})
	vim.api.nvim_create_autocmd("CursorHold", {
		group = "nvim_lsp_floating_window",
		callback = function()
			local opts = {
				border = 'rounded',
				source = 'always',
				prefix = ' ',
				scope = 'cursor',
			}
			vim.diagnostic.open_float(opts)
		end
	})
end

local function toggle_auto_floating_window()
	if vim.g.nvim_lsp_diagnostic_enable_auto_floating_window then
		vim.api.nvim_del_augroup_by_name("nvim_lsp_floating_window")
	else
		create_floating_window_autocmd()
	end
	vim.g.nvim_lsp_diagnostic_enable_auto_floating_window = not vim.g.nvim_lsp_diagnostic_enable_auto_floating_window
end
vim.api.nvim_create_user_command('LspFloatToggle', toggle_auto_floating_window, {})

if vim.g.nvim_lsp_diagnostic_enable_auto_floating_window == nil then
	-- 默认关闭自动浮窗，因为这会挡住其它手动打开的浮窗，textDocument/hover (<space>K)
	vim.g.nvim_lsp_diagnostic_enable_auto_floating_window = false
end
if vim.g.nvim_lsp_diagnostic_enable_auto_floating_window then
	create_floating_window_autocmd()
end
