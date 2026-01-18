local M = {}

M.load = function()
  local lazyvim_path = vim.fn.stdpath "data" .. "/lazy/LazyVim"
  if vim.uv.fs_stat(lazyvim_path) then
    vim.opt.rtp:prepend(lazyvim_path)
    M.setup()
  end
end

M.setup = function()
  _G.lazyvim_docs = false
  _G.LazyVim = require "lazyvim.util"

  vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

  M.setup_lazy_file()

  local lazyVimLspUtil = require "lazyvim.util.lsp"
  lazyVimLspUtil.format = require("utils.lsp").format
  lazyVimLspUtil.formatter = require("utils.lsp").formatter
end

M.root = function(...)
  return require("lazyvim.util.root").get(...)
end

M.root_git = function(...)
  return require("lazyvim.util.root").git(...)
end

M.safe_keymap_set = function(...)
  return require("lazyvim.util").safe_keymap_set(...)
end

M.setup_lazy_file = function(...)
  return require("lazyvim.util.plugin").lazy_file(...)
end

M.memoize = function(...)
  return require("lazyvim.util").memoize(...)
end

return M
