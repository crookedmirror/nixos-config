local M = {}

M.run_expr = function(expr)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(expr, true, false, true), "n", true)
end

return M
