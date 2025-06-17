local M = {}

M.has_typst_executable = vim.fn.executable("typst") == 1
M.has_go_executable = vim.fn.executable("go") == 1
M.has_rust_executable = vim.fn.executable("rustc") == 1
M.has_coqtop_executable = vim.fn.executable("coqtop") == 1
M.has_pdflatex_executable = vim.fn.executable("pdflatex") == 1
M.has_quarto_executable = vim.fn.executable("quarto") == 1
M.has_treesitter_cli_executable = vim.fn.executable("tree-sitter") == 1

return M
