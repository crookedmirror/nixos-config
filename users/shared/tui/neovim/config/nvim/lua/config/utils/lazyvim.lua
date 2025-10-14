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
  
  require("lazyvim.util.plugin").lazy_file();
end

return M
