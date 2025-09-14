local M = {}

M.has_ccls_executable = vim.fn.executable("ccls") == 1
M.has_typst_executable = vim.fn.executable("typst") == 1
M.has_rust_executable = vim.fn.executable("rustc") == 1
M.has_quarto_executable = vim.fn.executable("quarto") == 1

return M
