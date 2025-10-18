local M = {}

M.tbl_merge = function(...)
  return require("lazy.util").merge(...)
end

return M
