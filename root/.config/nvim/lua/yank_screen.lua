local M = {}

local function current_win_info()
  local winid = vim.api.nvim_get_current_win()
  local info = vim.fn.getwininfo(winid)[1]
  return winid, info
end

-- 不用 visualmode()，直接看当前实时 mode
local function get_current_visual_type()
  local m = vim.fn.mode(1)

  -- 常见情况：
  -- v / vs / vS / CTRL-V / CTRL-S / V / Vs / VS
  if m:sub(1, 1) == "V" then
    return "V"
  end

  -- Ctrl-V / blockwise，mode() 里通常是 ^V（ASCII 22）
  if m:byte(1) == 22 then
    return vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
  end

  -- 默认按字符选区处理
  return "v"
end

local function get_current_visual_region()
  local visual_type = get_current_visual_type()

  return vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), {
    type = visual_type,
    exclusive = false,
    eol = false,
  })
end

local function get_current_visual_line_range()
  local region = get_current_visual_region()
  if not region or vim.tbl_isempty(region) then
    return nil, nil, nil
  end

  local start_line = region[1][1][2]
  local end_line = region[#region][1][2]

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  return start_line, end_line, region
end

local function read_screen_row_text(row, include_gutter)
  local _, info = current_win_info()
  if not info then
    return ""
  end

  local start_col = include_gutter and info.wincol or (info.wincol + info.textoff)
  local end_col = info.wincol + info.width - 1
  if end_col < start_col then
    return ""
  end

  local chars = {}
  for col = start_col, end_col do
    chars[#chars + 1] = vim.fn.screenstring(row, col)
  end

  return table.concat(chars):gsub("%s+$", "")
end

local function get_screen_lines_for_buffer_line(lnum, opts)
  opts = opts or {}
  local include_gutter = opts.include_gutter or false

  local winid = vim.api.nvim_get_current_win()
  local pos = vim.fn.screenpos(winid, lnum, 1)
  if not pos or pos.row == 0 then
    return {}
  end

  local last_line = vim.api.nvim_buf_line_count(0)
  local row1 = pos.row
  local row2

  if vim.fn.foldclosed(lnum) ~= -1 then
    row2 = row1 + 1
  elseif lnum >= last_line then
    row2 = row1 + 1
  else
    local next_pos = vim.fn.screenpos(winid, lnum + 1, 1)
    if next_pos and next_pos.row ~= 0 and next_pos.row > row1 then
      row2 = next_pos.row
    else
      row2 = row1 + 1
    end
  end

  local out = {}
  for row = row1, row2 - 1 do
    out[#out + 1] = read_screen_row_text(row, include_gutter)
  end
  return out
end

function M.yank_visual_exact_screen_text(opts)
  opts = opts or {}
  local include_gutter = opts.include_gutter or false
  local copy_to_plus = opts.copy_to_plus ~= false
  local leave_visual = opts.leave_visual ~= false

  local ok, start_line, end_line = pcall(function()
    local s, e = get_current_visual_line_range()
    return s, e
  end)

  if not ok or not start_line or not end_line then
    vim.notify("Failed to get current visual region", vim.log.levels.ERROR)
    return
  end

  local out = {}
  local seen_fold_start = {}
  local lnum = start_line

  while lnum <= end_line do
    local fc = vim.fn.foldclosed(lnum)

    if fc ~= -1 then
      if not seen_fold_start[fc] then
        seen_fold_start[fc] = true
        local lines = get_screen_lines_for_buffer_line(fc, {
          include_gutter = include_gutter,
        })
        vim.list_extend(out, lines)
      end
      lnum = vim.fn.foldclosedend(lnum) + 1
    else
      local lines = get_screen_lines_for_buffer_line(lnum, {
        include_gutter = include_gutter,
      })
      vim.list_extend(out, lines)
      lnum = lnum + 1
    end
  end

  local text = table.concat(out, "\n")
  vim.fn.setreg('"', text)
  if copy_to_plus then
    vim.fn.setreg("+", text)
  end

  if leave_visual then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
      "n",
      false
    )
  end

  local n = #out
  vim.notify(string.format("%d line%s yanked", n, n == 1 and "" or "s"))

  return {
    text = text,
    line_count = n,
    start_line = start_line,
    end_line = end_line,
  }
end

vim.keymap.set("x", "yv", function()
  M.yank_visual_exact_screen_text({
    include_gutter = false,
    copy_to_plus = true,
    leave_visual = true,
  })
end, { desc = "Yank exact screen text from current visual selection" })

return M
