-- Markdown ATX heading commands are buffer-local through this ftplugin.

local function fail(message)
	vim.notify(message, vim.log.levels.ERROR)
end

local function heading_in(section)
	for child in section:iter_children() do
		if child:type() == "atx_heading" then
			return child
		end
	end
end

local function locate_section(node, row, col, selected)
	if not vim.treesitter.is_in_node_range(node, row, col) then
		return selected
	end
	if node:type() == "section" and heading_in(node) then
		selected = node
	end
	for child in node:iter_children() do
		selected = locate_section(child, row, col, selected)
	end
	return selected
end

local function marker_for(heading)
	for child in heading:iter_children() do
		if child:type():match("^atx_h[1-6]_marker$") then
			return child
		end
	end
end

local function collect_headings(node, headings)
	if node:type() == "atx_heading" then
		local marker = marker_for(node)
		if marker then
			local row, start_col, _, end_col = marker:range()
			headings[#headings + 1] = {
				row = row,
				start_col = start_col,
				end_col = end_col,
				level = end_col - start_col,
			}
		end
		return
	end
	for child in node:iter_children() do
		collect_headings(child, headings)
	end
end

local function change_heading_tree(direction)
	if vim.fn.mode(1) ~= "n" then
		fail("Markdown heading commands are only available in Normal mode")
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
	if not ok or not parser then
		fail("The Markdown Tree-sitter parser is unavailable")
		return
	end

	local tree = parser:parse()[1]
	local root = tree and tree:root()
	if not root then
		fail("Could not parse the Markdown buffer")
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local section = locate_section(root, cursor[1] - 1, cursor[2], nil)
	if not section then
		fail("The cursor is not inside an ATX heading section")
		return
	end

	local headings = {}
	collect_headings(section, headings)
	if #headings == 0 then
		fail("The cursor is not inside an ATX heading section")
		return
	end
	for _, heading in ipairs(headings) do
		if heading.level + direction < 1 or heading.level + direction > 6 then
			fail("Cannot change heading levels beyond H1 and H6")
			return
		end
	end

	for _, heading in ipairs(headings) do
		vim.api.nvim_buf_set_text(
			bufnr,
			heading.row,
			heading.start_col,
			heading.row,
			heading.end_col,
			{ string.rep("#", heading.level + direction) }
		)
	end
end

pcall(vim.api.nvim_buf_del_user_command, 0, "MarkdownHeadingIncrease")
pcall(vim.api.nvim_buf_del_user_command, 0, "MarkdownHeadingDecrease")

vim.api.nvim_buf_create_user_command(0, "MarkdownHeadingIncrease", function()
	change_heading_tree(-1)
end, { desc = "Increase current ATX heading and its children" })

vim.api.nvim_buf_create_user_command(0, "MarkdownHeadingDecrease", function()
	change_heading_tree(1)
end, { desc = "Decrease current ATX heading and its children" })

local cleanup_id = vim.api.nvim_create_autocmd("FileType", {
	buffer = 0,
	callback = function(args)
		if vim.bo[args.buf].filetype ~= "markdown" then
			pcall(vim.api.nvim_buf_del_user_command, args.buf, "MarkdownHeadingIncrease")
			pcall(vim.api.nvim_buf_del_user_command, args.buf, "MarkdownHeadingDecrease")
			pcall(vim.api.nvim_del_autocmd, cleanup_id)
		end
	end,
})
