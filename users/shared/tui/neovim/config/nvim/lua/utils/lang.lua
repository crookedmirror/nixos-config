local M = {}

M.list_merge = function(...)
  local lists = {}
  for _, list in ipairs { ... } do
    vim.list_extend(lists, list)
  end
  return lists
end

M.tbl_merge = function(...)
  return require("lazy.util").merge(...)
end

return M
