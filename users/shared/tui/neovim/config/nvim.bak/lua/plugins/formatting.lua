local nvim_utils = require "utils.nvim"
local lazy_utils = require "utils.lazy"
local format_utils = require "utils.format"
local lang_utils = require "utils.lang"

return {
  {
    "stevearc/conform.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
    },
    cmd = { "ConformInfo", "LazyFormat", "LazyFormatInfo" },
    event = "VeryLazy",
    keys = {
      {
        "<leader>lf",
        function()
          require("utils.format").format { force = true }
        end,
        desc = "Format Buffer",
        mode = "n",
      },
      {
        "<leader>lf",
        function()
          require("utils.format").format { force = true }
        end,
        desc = "Format Selection",
        mode = "v",
      },
      {
        "<leader>lF",
        function()
          require("conform").format { force = true, formatters = { "injected" } }
        end,
        desc = "Format Buffer (Injected Langs)",
        mode = "n",
      },
      {
        "<leader>lF",
        function()
          require("conform").format { force = true, formatters = { "injected" } }
        end,
        desc = "Format Selection (Injected Langs)",
        mode = "v",
      },
    },
    init = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

      nvim_utils.autocmd("User", {
        group = nvim_utils.augroup "install_formatter_cmds",
        pattern = "VeryLazy",
        callback = function()
          format_utils.setup()
        end,
      })

      -- Install the conform formatter on VeryLazy
      lazy_utils.on_very_lazy(function()
        format_utils.register {
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf, format_opts, cb)
            local opts = lang_utils.tbl_merge({}, format_opts, { bufnr = buf })
            require("conform").format(opts, cb)
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        }
      end)
    end,
    opts = {
      default_format_opts = {
        async = true,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {},
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
}
