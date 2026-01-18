local M = {}

M.run_expr = function(expr)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(expr, true, false, true), "n", true)
end

M.map = function(mode, lhs, rhs, desc, opts)
  if type(desc) == "table" then
    opts = desc
  end
  if not desc then
    desc = ""
  end
  if not opts then
    opts = {}
  end
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
