local buf = vim.api.nvim_get_current_buf()
local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
local target, parent, leaf, multiline
for row, line in ipairs(lines) do
	if line:find("BaseModelLoader.load_model", 1, true) then
		target = row
	elseif line:find("FlashInferMLASparseSM120Impl.__init__", 1, true) then
		leaf = row
	elseif line:find("self.host_manager.publish_blocks(", 1, true) then
		multiline = row
	elseif line:find("MLAAttention.__init__", 1, true) then
		parent = row
	end
end
assert(
	target and parent and leaf and multiline,
	"open the real vLLM request-flow Markdown file before running this test"
)

vim.wo.foldlevel = 99
vim.cmd("normal! zX")
vim.api.nvim_win_set_cursor(0, { target, 0 })
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("za", true, false, true), "mx", false)
assert(vim.fn.foldclosed(target) == target, "za did not close the selected deep node")
assert(vim.fn.foldclosedend(target) > target, "selected deep node did not fold its descendants")
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("za", true, false, true), "mx", false)
assert(vim.fn.foldclosed(target) == -1, "second za did not reopen the selected node")

vim.api.nvim_win_set_cursor(0, { parent, 0 })
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("za", true, false, true), "mx", false)
assert(vim.fn.foldclosed(parent) == parent, "za did not fold the shallower parent node")
assert(vim.fn.foldclosedend(parent) > parent, "parent fold did not include its child")
print("PASS: za folds and reopens deep nodes and folds their descendants")
vim.api.nvim_win_set_cursor(0, { multiline, 0 })
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("za", true, false, true), "mx", false)
assert(vim.fn.foldclosed(multiline) == multiline, "multiline tree node did not fold")
assert(
	vim.fn.foldclosedend(multiline) == multiline + 5,
	"multiline fold ended at " .. vim.fn.foldclosedend(multiline) .. " instead of " .. (multiline + 5)
)
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("za", true, false, true), "mx", false)
assert(vim.fn.foldclosed(multiline) == -1, "second za did not reopen the multiline node")

require("vllmclass.highlight").setup()
local highlight_buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(highlight_buf)
vim.api.nvim_buf_set_lines(highlight_buf, 0, -1, false, {
	"<!-- vllmclass -->",
	"Request outside",
	"```python",
	"Request inside",
	"```",
	"Request after",
	"~~~py",
	"Request alias",
	"~~~",
	"Request final",
})
vim.api.nvim_exec_autocmds("BufEnter", { buffer = highlight_buf })
local namespace = vim.api.nvim_get_namespaces().vllmclass
local rows = {}
for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(highlight_buf, namespace, 0, -1, {})) do
	rows[mark[2] + 1] = true
end
assert(not rows[4] and not rows[8], "Python code block received a vllmclass extmark")
assert(rows[2] and rows[6] and rows[10], "vllmclass extmarks were not restored outside Python code blocks")
print("PASS: Python code blocks suppress vllmclass extmarks")
