local lazy_utils = require "utils.lazy"
local lang_utils = require "utils.lang"
local nvim_utils = require "utils.nvim"

local M = {}

M.format = function(opts, cb)
  opts = vim.tbl_deep_extend(
    "force",
    {},
    opts or {},
    lazy_utils.opts("nvim-lspconfig").format or {},
    lazy_utils.opts("conform.nvim").default_format_opts or {}
  )
  local has_conform, conform = pcall(require, "conform")
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if has_conform then
    opts.formatters = {}
    conform.format(opts, cb)
  else
    vim.lsp.buf.format(opts)
  end
end

M.formatter = function(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf, format_opts, cb)
      local _opts = lang_utils.tbl_merge({}, format_opts, filter, { bufnr = buf })
      M.format(_opts, cb)
    end,
    sources = function(buf)
      local clients = vim.lsp.get_clients(lang_utils.tbl_merge({}, filter, { bufnr = buf }))
      local ret = vim.tbl_filter(function(client)
        return client:supports_method "textDocument/formatting" or client:supports_method "textDocument/rangeFormatting"
      end, clients)
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return lang_utils.tbl_merge(ret, opts)
end

M.on_attach = function(...)
  return require("lazyvim.util.lsp").on_attach(...)
end

M.on_supports_method = function(...)
  return require("lazyvim.util.lsp").on_supports_method(...)
end

M.setup = function(...)
  return require("lazyvim.util.lsp").setup(...)
end

M.on_dynamic_capability = function(...)
  return require("lazyvim.util.lsp").on_dynamic_capability(...)
end

---Sets up autocommands to enable/disable a feature based on mode.
---The feature will be disabled on InsertEnter and entering Visual mode,
---and enabled on InsertLeave and leaving Visual mode.
M.setup_mode_toggle = function(name, disable_fn, enable_fn)
  local function create_callback(fn)
    return function(event)
      vim.schedule(function()
        fn(event)
      end)
    end
  end

  nvim_utils.autocmd("InsertEnter", {
    group = nvim_utils.augroup("disable_" .. name .. "_on_insert_enter"),
    pattern = "*",
    callback = create_callback(disable_fn),
  })
  nvim_utils.autocmd("InsertLeave", {
    group = nvim_utils.augroup("enable_" .. name .. "_on_insert_leave"),
    pattern = "*",
    callback = create_callback(enable_fn),
  })
  nvim_utils.autocmd("ModeChanged", {
    group = nvim_utils.augroup("disable_" .. name .. "_on_visual_enter"),
    pattern = "*:[vV]",
    callback = function(event)
      local cur_mode = vim.fn.mode()
      if cur_mode ~= "v" and cur_mode ~= "V" then
        return
      end
      vim.schedule(function()
        disable_fn(event)
      end)
    end,
  })
  nvim_utils.autocmd("ModeChanged", {
    group = nvim_utils.augroup("enable_" .. name .. "_on_visual_leave"),
    pattern = "[vV]:*",
    callback = create_callback(enable_fn),
  })
end

return M
