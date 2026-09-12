local M = {}
local baselines = {}

local function notify(message)
  local ok, fidget = pcall(require, "fidget")
  if ok and fidget.notify then
    fidget.notify(message)
  else
    vim.notify(message)
  end
end

function M.baseline(buf)
  return baselines[buf or vim.api.nvim_get_current_buf()]
end

function M.toggle()
  local buf = vim.api.nvim_get_current_buf()
  local MiniDiff = require("mini.diff")
  if baselines[buf] then
    baselines[buf] = nil
    MiniDiff.disable(buf)
    notify("Live diff disabled")
    return
  end
  baselines[buf] = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  MiniDiff.enable(buf)
  MiniDiff.set_ref_text(buf, baselines[buf])
  MiniDiff.toggle_overlay(buf)
  notify("Live diff enabled; baseline captured")
end

return M
