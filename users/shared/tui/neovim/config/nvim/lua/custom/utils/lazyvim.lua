local M = {}

M.load = function()
  local lazyvim_path = vim.fn.stdpath "data" .. "/lazy/LazyVim"
  if vim.uv.fs_stat(lazyvim_path) then
    vim.opt.rtp:prepend(lazyvim_path)
    M.setup()
  else
    -- LazyVim not installed yet, register LazyFile as alias for BufReadPost
    M.setup_lazy_file_fallback()
  end
end

M.setup = function()
  _G.lazyvim_docs = false
  _G.LazyVim = require "lazyvim.util"

  vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

  local ok, err = pcall(M.setup_lazy_file)
  if not ok then
    vim.notify("LazyFile setup failed: " .. tostring(err), vim.log.levels.WARN)
    M.setup_lazy_file_fallback()
  end

  local lazyVimLspUtil = require "lazyvim.util.lsp"
  lazyVimLspUtil.format = require("custom.utils.lsp").format
  lazyVimLspUtil.formatter = require("custom.utils.lsp").formatter
end

-- Fallback: Register LazyFile as a simple event alias
M.setup_lazy_file_fallback = function()
  local Event = require "lazy.core.handler.event"
  Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
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
