local M = {}

M.autocmd = vim.api.nvim_create_autocmd

M.augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

M.set_timeout = function(ms, callback)
  local timer = vim.loop.new_timer()
  timer:start(ms, 0, function()
    -- Stop and close the timer
    timer:stop()
    timer:close()

    -- Schedule the callback to run on the main thread
    vim.schedule(callback)
  end)
end

return M
