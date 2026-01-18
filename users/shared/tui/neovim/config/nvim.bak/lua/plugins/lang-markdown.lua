local nvim_utils = require "utils.nvim"
local keymaps_utils = require "utils.keymaps"
local lang_utils = require "utils.lang"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        marksman = {
          enabled = false,
          mason = false,
        },
      },
    },
  },

  -- NOTE: lang-web.lua adds Prettier formatting for Markdown
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      nvim_utils.autocmd({ "BufEnter" }, {
        group = nvim_utils.augroup "load_peek_mappings",
        pattern = "*.md",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          keymaps_utils.map("n", "<leader>fm", "<cmd>lua require('peek').open()<CR>", "open markdown previewer", {
            buffer = bufnr,
          })
          keymaps_utils.map("n", "<leader>fM", "<cmd>lua require('peek').close()<CR>", "close markdown previewer", {
            buffer = bufnr,
          })
        end,
      })
    end,
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      indent = {
        exclude_filetypes = { "markdown" },
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    opts = {
      file_types = { "markdown" },
      change_events = { "DiagnosticChanged" },
      latex = {
        enabled = false,
      },
      heading = {
        sign = false,
        icons = { "󰼏  ", "󰎨  ", "󰼑  ", "󰎲  ", "󰼓  ", "󰎴  " },
      },
      code = {
        sign = false,
        border = "thin",
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
      },
      link = {
        wiki = {
          body = function(ctx)
            if ctx.alias then
              return ctx.alias
            end
            -- get wiki conceal title from zk hint diagnostic
            -- source: https://github.com/MeanderingProgrammer/render-markdown.nvim/discussions/228
            local diagnostics = vim.diagnostic.get(ctx.buf, {
              lnum = ctx.row,
              severity = vim.diagnostic.severity.HINT,
            })
            for _, diagnostic in ipairs(diagnostics) do
              if diagnostic.source == "zk" then
                return diagnostic.message
              end
            end
            return nil
          end,
        },
      },
      overrides = {
        buftype = {
          nofile = {
            enabled = false,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        defaults = {
          function(default)
            local filetype = vim.api.nvim_buf_get_option(0, "filetype")
            local has_render_markdown = package.loaded["render-markdown"]
            if has_render_markdown then
              if filetype == "markdown" then
                return lang_utils.list_merge(default, { "markdown" })
              end
            end
            return nil
          end,
        },
        providers = {
          markdown = {
            name = "RenderMarkdown",
            module = "render-markdown.integ.blink",
            kind = "RenderMarkdown",
          },
        },
      },
    },
  },
}
