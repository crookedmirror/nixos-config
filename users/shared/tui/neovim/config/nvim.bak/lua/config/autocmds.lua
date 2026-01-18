-- Disable auto-formatting for specific filetypes 
-- TODO: remove after portiong format.lua from LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.b.autoformat = false
  end,
})
