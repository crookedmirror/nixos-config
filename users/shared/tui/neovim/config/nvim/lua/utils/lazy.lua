local constants = require "constants"
local keymaps_utils = require "utils.keymaps"

local M = {}

M.install = function()
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    constants.first_install = true

    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  end
  vim.opt.rtp:prepend(lazypath)
end

M.load_mappings = function()
  local map = keymaps_utils.map
  map("n", "<leader>L", "<cmd>Lazy<cr>", "Lazy")
end

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
