--- 自动浮窗展示diagnostic
local function create_floating_window_autocmd()
	vim.api.nvim_create_augroup("nvim_lsp_floating_window", {})
	vim.api.nvim_create_autocmd("CursorHold", {
		group = "nvim_lsp_floating_window",
		callback = function()
			local opts = {
				border = "rounded",
				source = "always",
				prefix = " ",
				scope = "cursor",
			}
			vim.diagnostic.open_float(opts)
		end,
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
vim.api.nvim_create_user_command("LspFloatToggle", toggle_auto_floating_window, {})

if vim.g.nvim_lsp_diagnostic_enable_auto_floating_window == nil then
	-- 默认关闭自动浮窗，因为这会挡住其它手动打开的浮窗，textDocument/hover (<space>K)
	vim.g.nvim_lsp_diagnostic_enable_auto_floating_window = false
end
if vim.g.nvim_lsp_diagnostic_enable_auto_floating_window then
	create_floating_window_autocmd()
end

-- local USE_VIRTUAL_LINE = vim.version.gt(vim.version(), { 0, 10, 3 })
local USE_VIRTUAL_LINE = false
if USE_VIRTUAL_LINE then
	vim.keymap.set("n", "<leader>da", function()
		local old_config = vim.diagnostic.config().virtual_lines
		if old_config then
			vim.diagnostic.config({ virtual_lines = false })
		else
			vim.diagnostic.config({ virtual_lines = { current_line = true } })
		end
	end, { desc = "Toggle diagnostic virtual_lines" })
else
	vim.keymap.set("n", "<leader>da", vim.diagnostic.open_float)
end

local function setup_vim_diagnostic()
	vim.diagnostic.config({
		-- virtual text is too noisy!
		virtual_text = false,
		virtual_lines = USE_VIRTUAL_LINE and { current_line = true },
		-- ERROR 比 INFO优先级更高显示
		severity_sort = true,
	})
end

local function setup_vim_diagnostic_on_attach()
	setup_vim_diagnostic()
	vim.keymap.set("n", "]da", function()
		vim.diagnostic.jump({ count = 1, float = not USE_VIRTUAL_LINE })
	end, bufopts)
	vim.keymap.set("n", "[da", function()
		vim.diagnostic.jump({ count = -1, float = not USE_VIRTUAL_LINE })
	end, bufopts)
	vim.keymap.set("n", "]dw", function()
		vim.diagnostic.jump({
			count = 1,
			severity = { min = vim.diagnostic.severity.WARN },
			float = not USE_VIRTUAL_LINE,
		})
	end, bufopts)
	vim.keymap.set("n", "[dw", function()
		vim.diagnostic.jump({
			count = -1,
			severity = { min = vim.diagnostic.severity.WARN },
			float = not USE_VIRTUAL_LINE,
		})
	end, bufopts)
	vim.keymap.set("n", "]de", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = not USE_VIRTUAL_LINE })
	end, bufopts)
	vim.keymap.set("n", "[de", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = not USE_VIRTUAL_LINE })
	end, bufopts)
end

local M = {
	setup_vim_diagnostic = setup_vim_diagnostic,
	setup_vim_diagnostic_on_attach = setup_vim_diagnostic_on_attach,
}
return M
