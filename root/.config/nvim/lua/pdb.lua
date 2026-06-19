local M = {}

local ns = vim.api.nvim_create_namespace("pdb-current-line")
local breakpoint_sign_group = "pdb-breakpoints"
local breakpoint_sign_name = "PdbBreakpoint"
local breakpoint_sign_hl = "PdbBreakpointSign"
local current_line_hl = "PdbCurrentLine"

local state = {
  job_id = nil,
  term_buf = nil,
  code_win = nil,
  pending_output = "",
  last_location = nil,
  cwd = nil,
  current_buf = nil,
  breakpoint_by_id = {},
  breakpoint_by_location = {},
  next_sign_id = 1,
  -- bt/where/w 只是在 terminal 里查看堆栈；这些输出包含 file(line) 格式，
  -- 但不代表 pdb 当前停住的位置变化，不能触发源码窗口跳转。
  suppress_location_output = false,
  last_command_was_stack = false,
}

local function setup_highlights()
  vim.api.nvim_set_hl(0, breakpoint_sign_hl, { fg = "#ff5555" })
  vim.api.nvim_set_hl(0, current_line_hl, { bg = "#3a2f1b" })

  vim.fn.sign_define(breakpoint_sign_name, {
    text = "●",
    texthl = breakpoint_sign_hl,
    linehl = "",
    numhl = "",
  })
end

setup_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_highlights,
})

-- 记录最近进入的非 terminal 窗口，作为代码跳转目标窗口。
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.bo[buf].buftype

    if buftype ~= "terminal" then
      state.code_win = win
    end
  end,
})

local function strip_ansi(text)
  -- CSI 转义序列，例如颜色、清行等。
  text = text:gsub("\27%[[0-9;?]*[ -/]*[@-~]", "")

  -- OSC 转义序列，例如修改终端标题。
  text = text:gsub("\27%].-\7", "")
  text = text:gsub("\27%].-\27\\", "")

  return text
end

local function trim(text)
  return text:match("^%s*(.-)%s*$")
end

local function location_key(filename, linenr)
  return filename .. ":" .. linenr
end

local function buf_for_file(filename)
  local buf = vim.fn.bufnr(filename)

  if buf == -1 then
    buf = vim.fn.bufadd(filename)
  end

  if buf > 0 and not vim.api.nvim_buf_is_loaded(buf) then
    vim.fn.bufload(buf)
  end

  if buf > 0 and vim.api.nvim_buf_is_valid(buf) then
    return buf
  end

  return nil
end

local function resolve_file(filename)
  filename = trim(filename)

  -- pdb 可能显示这些伪文件名。
  if filename == "" or filename:match("^<.*>$") then
    return nil
  end

  -- 去掉 pdb++ 等工具可能添加的前缀。
  -- 例如：
  --   [0] > /tmp/foo.py(10)func()
  filename = filename:gsub("^%[%d+%]%s*>%s*", "")
  filename = filename:gsub("^>%s*", "")
  filename = trim(filename)

  if vim.fn.fnamemodify(filename, ":p") == filename then
    return vim.fs.normalize(filename)
  end

  return vim.fs.normalize(state.cwd .. "/" .. filename)
end

local function clear_current_line()
  if state.current_buf and vim.api.nvim_buf_is_valid(state.current_buf) then
    vim.api.nvim_buf_clear_namespace(state.current_buf, ns, 0, -1)
  end

  state.current_buf = nil
end

local function set_current_line(buf, linenr)
  clear_current_line()

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.api.nvim_buf_set_extmark(buf, ns, linenr - 1, 0, {
    line_hl_group = current_line_hl,
    priority = 70,
  })
  state.current_buf = buf
end

local function unplace_breakpoint_sign(record)
  if not record or not record.buf or not vim.api.nvim_buf_is_valid(record.buf) then
    return
  end

  vim.fn.sign_unplace(breakpoint_sign_group, {
    buffer = record.buf,
    id = record.sign_id,
  })
end

local function remove_breakpoint_record(record)
  if not record then
    return
  end

  unplace_breakpoint_sign(record)
  state.breakpoint_by_location[record.key] = nil

  for id in pairs(record.ids) do
    state.breakpoint_by_id[id] = nil
  end
end

local function clear_breakpoint_signs()
  for _, record in pairs(state.breakpoint_by_location) do
    unplace_breakpoint_sign(record)
  end

  state.breakpoint_by_id = {}
  state.breakpoint_by_location = {}
end

local function place_breakpoint(filename, linenr, breakpoint_id)
  filename = resolve_file(filename)
  linenr = tonumber(linenr)

  if not filename or not linenr or vim.fn.filereadable(filename) ~= 1 then
    return
  end

  local buf = buf_for_file(filename)

  if not buf then
    return
  end

  local line_count = vim.api.nvim_buf_line_count(buf)

  if linenr < 1 or linenr > line_count then
    return
  end

  local key = location_key(filename, linenr)
  local record = state.breakpoint_by_location[key]

  if not record then
    record = {
      key = key,
      filename = filename,
      linenr = linenr,
      buf = buf,
      sign_id = state.next_sign_id,
      ids = {},
    }
    state.next_sign_id = state.next_sign_id + 1
    state.breakpoint_by_location[key] = record

    vim.fn.sign_place(record.sign_id, breakpoint_sign_group, breakpoint_sign_name, buf, {
      lnum = linenr,
      priority = 90,
    })
  end

  if breakpoint_id then
    breakpoint_id = tonumber(breakpoint_id)

    if breakpoint_id then
      record.ids[breakpoint_id] = true
      state.breakpoint_by_id[breakpoint_id] = record
    end
  end
end

local function remove_breakpoint_by_id(breakpoint_id)
  breakpoint_id = tonumber(breakpoint_id)

  if not breakpoint_id then
    return
  end

  local record = state.breakpoint_by_id[breakpoint_id]

  if not record then
    return
  end

  state.breakpoint_by_id[breakpoint_id] = nil
  record.ids[breakpoint_id] = nil

  if next(record.ids) == nil then
    remove_breakpoint_record(record)
  end
end

local function remove_breakpoint_by_location(filename, linenr)
  filename = resolve_file(filename)
  linenr = tonumber(linenr)

  if not filename or not linenr then
    return
  end

  remove_breakpoint_record(
    state.breakpoint_by_location[location_key(filename, linenr)]
  )
end

local function parse_location(line)
  line = strip_ansi(line)

  -- 标准 pdb：
  --   > /tmp/foo.py(123)func()
  --
  -- pdb where/bt：
  --     /tmp/foo.py(123)func()
  --
  -- pdb++：
  --   [0] > /tmp/foo.py(123)func()
  local filename, linenr = line:match(">%s*(.-)%((%d+)%)")

  if not filename then
    filename, linenr = line:match("^%s*(.-)%((%d+)%)")
  end

  if not filename then
    return nil
  end

  filename = resolve_file(filename)
  linenr = tonumber(linenr)

  if not filename or not linenr then
    return nil
  end

  -- 避免把普通的 function_call(123) 误认为源码位置。
  if vim.fn.filereadable(filename) ~= 1 then
    return nil
  end

  return filename, linenr
end

local function find_code_window()
  if state.code_win and vim.api.nvim_win_is_valid(state.code_win) then
    local buf = vim.api.nvim_win_get_buf(state.code_win)

    if vim.bo[buf].buftype ~= "terminal" then
      return state.code_win
    end
  end

  -- 原窗口已经关闭时，寻找任意非 terminal 窗口。
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)

    if vim.bo[buf].buftype ~= "terminal" then
      state.code_win = win
      return win
    end
  end

  return nil
end

local function jump_to_location(filename, linenr)
  local location = filename .. ":" .. linenr

  -- pdb 经常重复打印当前位置，避免反复触发 BufEnter 等事件。
  if state.last_location == location then
    return
  end

  state.last_location = location

  vim.schedule(function()
    local win = find_code_window()

    if not win then
      return
    end

    vim.api.nvim_win_call(win, function()
      local escaped = vim.fn.fnameescape(filename)
      vim.cmd("keepalt edit " .. escaped)

      local line_count = vim.api.nvim_buf_line_count(0)
      local target_line = math.min(math.max(linenr, 1), line_count)

      vim.api.nvim_win_set_cursor(0, { target_line, 0 })
      set_current_line(vim.api.nvim_get_current_buf(), target_line)
      vim.cmd("normal! zz")
    end)
  end)
end

local function parse_breakpoint_status(line)
  line = strip_ansi(line)

  local breakpoint_id, filename, linenr =
    line:match("^%s*Breakpoint%s+(%d+)%s+at%s+(.+):(%d+)%s*$")

  if breakpoint_id then
    place_breakpoint(filename, linenr, breakpoint_id)
    return
  end

  breakpoint_id, filename, linenr =
    line:match("^%s*Deleted%s+[Bb]reakpoint%s+(%d+)%s+at%s+(.+):(%d+)%s*$")

  if breakpoint_id then
    remove_breakpoint_by_id(breakpoint_id)
    remove_breakpoint_by_location(filename, linenr)
    return
  end

  breakpoint_id, filename, linenr =
    line:match("^%s*(%d+)%s+breakpoint%s+.-%s+at%s+(.+):(%d+)%s*$")

  if breakpoint_id then
    place_breakpoint(filename, linenr, breakpoint_id)
  end
end

local function parse_pdb_command(line)
  line = strip_ansi(line)

  local command = line:match("%(Pdb%+*%)%s*(.-)%s*$")

  if not command then
    return nil
  end

  return trim(command)
end

local function process_clear_command(args)
  args = trim(args or "")

  -- 无参数 clear 会先等待确认，实际删除仍以 pdb 的 Deleted 输出为准。
  if args == "" then
    return
  end

  if args:find(":", 1, true) then
    local filename, linenr = args:match("^(.-):(%d+)%s*$")

    if filename and linenr then
      remove_breakpoint_by_location(filename, linenr)
    end

    return
  end

  for breakpoint_id in args:gmatch("%d+") do
    remove_breakpoint_by_id(breakpoint_id)
  end
end

local function is_stack_command(name)
  -- 堆栈查看命令会打印多行源码位置。跳转这些位置会打断当前编辑上下文。
  return name == "bt" or name == "where" or name == "w"
end

local function process_command_echo(line)
  local command = parse_pdb_command(line)

  if not command then
    return
  end

  if command == "" then
    -- pdb 空回车会重复上一条命令；如果上一条是 bt/where/w，
    -- 重复打印的堆栈也同样不应该驱动源码跳转。
    state.suppress_location_output = state.last_command_was_stack
    return
  end

  local name, args = command:match("^(%S+)%s*(.*)$")
  local stack_command = is_stack_command(name)

  state.suppress_location_output = stack_command
  state.last_command_was_stack = stack_command

  if name == "clear" or name == "cl" then
    process_clear_command(args)
  end
end

local function process_line(line)
  parse_breakpoint_status(line)
  process_command_echo(line)

  -- 在 bt/where/w 输出期间不要解析 file(line) 并跳转源码窗口。
  -- 这些行是堆栈列表，不是调试器当前执行行的通知。
  if state.suppress_location_output then
    return
  end

  local filename, linenr = parse_location(line)

  if filename then
    jump_to_location(filename, linenr)
  end
end

local function process_stdout(data)
  if not data then
    return
  end

  -- jobstart 的回调不保证每次给出完整行，因此需要自行拼接。
  local chunk = table.concat(data, "\n")
  state.pending_output = state.pending_output .. chunk

  while true do
    local newline = state.pending_output:find("\n", 1, true)

    if not newline then
      break
    end

    local line = state.pending_output:sub(1, newline - 1)
    state.pending_output = state.pending_output:sub(newline + 1)

    process_line(line)
  end

  -- pdb 提示符有时没有换行。只要已经包含完整的位置格式，也尝试解析。
  -- prompt 可能没有换行；即便如此，堆栈查看输出也必须继续禁止跳转。
  if not state.suppress_location_output and state.pending_output:match("%(%d+%)") then
    local filename, linenr = parse_location(state.pending_output)

    if filename then
      jump_to_location(filename, linenr)
      state.pending_output = ""
    end
  end
end

function M.start(args)
  if state.job_id and vim.fn.jobwait({ state.job_id }, 0)[1] == -1 then
    vim.notify("pdb is already running", vim.log.levels.WARN)
    return
  end

  if #args == 0 then
    vim.notify(
      "Usage: :Pdb python -m pdb program.py",
      vim.log.levels.ERROR
    )
    return
  end

  state.code_win = vim.api.nvim_get_current_win()
  state.cwd = vim.fn.getcwd()
  state.pending_output = ""
  state.last_location = nil
  state.suppress_location_output = false
  state.last_command_was_stack = false
  clear_current_line()
  clear_breakpoint_signs()

  vim.cmd("botright vnew")

  state.term_buf = vim.api.nvim_get_current_buf()

  vim.bo[state.term_buf].bufhidden = "hide"
  vim.bo[state.term_buf].swapfile = false

  state.job_id = vim.fn.jobstart(args, {
    term = true,
    cwd = state.cwd,

    on_stdout = function(_, data)
      process_stdout(data)
    end,

    on_exit = function(_, exit_code)
      vim.schedule(function()
        state.job_id = nil
        clear_current_line()
        clear_breakpoint_signs()

        vim.notify(
          ("pdb exited with code %d"):format(exit_code),
          exit_code == 0 and vim.log.levels.INFO
            or vim.log.levels.WARN
        )
      end)
    end,
  })

  if state.job_id <= 0 then
    vim.notify(
      "Failed to start pdb: jobstart returned " .. state.job_id,
      vim.log.levels.ERROR
    )
    state.job_id = nil
    return
  end

  vim.cmd("startinsert")
end

function M.send(command)
  if not state.job_id then
    vim.notify("pdb is not running", vim.log.levels.ERROR)
    return
  end

  vim.fn.chansend(state.job_id, command .. "\n")
end

function M.break_at_current_line()
  if not state.job_id then
    vim.notify("pdb is not running", vim.log.levels.ERROR)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)

  if vim.bo[buf].buftype == "terminal" then
    win = find_code_window()

    if not win then
      vim.notify("No source window found for breakpoint", vim.log.levels.ERROR)
      return
    end

    buf = vim.api.nvim_win_get_buf(win)
  end

  local filename = vim.api.nvim_buf_get_name(buf)

  if filename == "" then
    vim.notify("Current buffer has no file name", vim.log.levels.ERROR)
    return
  end

  filename = vim.fs.normalize(filename)

  if vim.fn.filereadable(filename) ~= 1 then
    vim.notify("Current buffer is not a readable file", vim.log.levels.ERROR)
    return
  end

  local linenr = vim.api.nvim_win_get_cursor(win)[1]
  M.send(("break %s:%d"):format(filename, linenr))
end

vim.api.nvim_create_user_command("Pdb", function(opts)
  M.start(opts.fargs)
end, {
  nargs = "+",
  complete = "file",
  desc = "Start pdb and follow source locations",
})

vim.api.nvim_create_user_command("PdbSend", function(opts)
  M.send(opts.args)
end, {
  nargs = "+",
  desc = "Send a command to pdb",
})

vim.api.nvim_create_user_command("Break", function()
  M.break_at_current_line()
end, {
  desc = "Set a pdb breakpoint at the current source line",
})

return M
