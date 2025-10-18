local M = {}

M.on_load = function(...)
  require("lazyvim.util").on_load(...)
end

M.opts = function(...)
  return require("lazyvim.util").opts(...)
end

M.has = function(...)
  return require("lazyvim.util").has(...)
end

M.on_very_lazy = function(...)
  require("lazyvim.util").on_very_lazy(...)
end

M.warn = function(...)
  return require("lazy.util").warn(...)
end

M.error = function(...)
  return require("lazy.util").error(...)
end

M.try = function(...)
  return require("lazy.util").try(...)
end

return M
