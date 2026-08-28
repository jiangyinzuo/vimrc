-- 由 Neovim 在 filetype == "python" 时自动加载。
-- 使用 nvim_buf_create_user_command 注册 buffer-local 命令，
-- 因此这些命令只存在于 Python buffer 中，其他 buffer 下不存在。

-- ftplugin 在同一 buffer 上可能被重新加载（filetype 切换回来时），
-- buffer-local 命令不会自动清除，先删除避免重复注册报错。
pcall(vim.api.nvim_buf_del_user_command, 0, "Pdb")
pcall(vim.api.nvim_buf_del_user_command, 0, "PdbSend")
pcall(vim.api.nvim_buf_del_user_command, 0, "Break")

local pdb = require("pdb")

vim.api.nvim_buf_create_user_command(0, "Pdb", function(opts)
  pdb.start(opts.fargs)
end, {
  nargs = "+",
  complete = "file",
  desc = "Start pdb and follow source locations",
})

vim.api.nvim_buf_create_user_command(0, "PdbSend", function(opts)
  pdb.send(opts.args)
end, {
  nargs = "+",
  desc = "Send a command to pdb",
})

vim.api.nvim_buf_create_user_command(0, "Break", function()
  pdb.break_at_current_line()
end, {
  desc = "Set a pdb breakpoint at the current source line",
})

-- buffer-local 命令在 buffer 存活期间不会自动消失：同一 buffer 的
-- filetype 被切换为非 python 时，清理命令并移除本 autocmd。
local cleanup_id = vim.api.nvim_create_autocmd("FileType", {
  buffer = 0,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "python" then
      pcall(vim.api.nvim_buf_del_user_command, args.buf, "Pdb")
      pcall(vim.api.nvim_buf_del_user_command, args.buf, "PdbSend")
      pcall(vim.api.nvim_buf_del_user_command, args.buf, "Break")
      pcall(vim.api.nvim_del_autocmd, cleanup_id)
    end
  end,
})
