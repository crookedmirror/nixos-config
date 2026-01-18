local prettier_supported = {
  "json",
  "markdown",
  "yaml",
}

if vim.g.lazyvim_prettier_needs_config == nil then
  vim.g.lazyvim_prettier_needs_config = false
end

-- source: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/formatting/prettier.lua
local function has_prettier_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  -- default filetypes are always supported
  if vim.tbl_contains(prettier_supported, ft) then
    return true
  end
  -- otherwise, check if a parser can be inferred
  local ret = vim.fn.system { "prettierd", "--file-info", "'" .. ctx.filename .. "'" }
  ---@type boolean, string?
  local ok, parser = pcall(function()
    return vim.fn.json_decode(ret).inferredParser
  end)
  return ok and parser and parser ~= vim.NIL
end

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        optional = true,
        opts = {
          ensure_installed = { "prettierd" },
        },
      },
    },
    opts = {
      formatters_by_ft = {
        ["json"] = { "prettierd" },
        ["markdown"] = { "prettierd" },
        ["yaml"] = { "prettierd" },
      },
      formatters = {
        prettierd = {
          condition = function(_, ctx)
            return has_prettier_parser(ctx)
              and (vim.g.lazyvim_prettier_needs_config ~= true or has_prettier_config(ctx))
          end,
        },
      },
    },
  },
}
