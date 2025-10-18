local icons_constants = require "constants.icons"
local lazy_utils = require "utils.lazy"
local blink_cmp_utils = require "utils-plugins.blink-cmp"
local keymaps_utils = require "utils.keymaps"

return {
  {
    -- PERF: runs very slow on nvim 0.11
    "saghen/blink.cmp",
    version = "v1.7.0",
    event = { "InsertEnter", "VeryLazy" },
    dependencies = {
      {
        "saghen/blink.compat",
        opts = {},
      },
      {
        "carbonid1/EmmetJSS",
        opts = {},
        config = function() end,
      },
      "L3MON4D3/LuaSnip",
      "dmitmel/cmp-cmdline-history",
    },
    opts = {
      enabled = function()
        local recording_macro = vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= ""
        return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false and not recording_macro
      end,
      appearance = {
        kind_icons = icons_constants.lsp_kind,
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      completion = {
        keyword = {
          -- will fuzzy match on the text before the cursor
          range = "prefix",
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          winblend = vim.o.pumblend,
          min_width = 15,
          max_height = 15,
          border = "rounded",
          draw = {
            align_to = "label",
            gap = 2,
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
            components = {
              label = {
                width = { fill = true, max = 40 },
                highlight = function(ctx)
                  -- label and label details
                  local highlights = {
                    { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                  }
                  if ctx.label_detail then
                    table.insert(
                      highlights,
                      { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                    )
                  end
                  -- characters matched on the label by the fuzzy matcher
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  return highlights
                end,
              },
            },
            -- highlight lsp source with treesitter
            treesitter = { "lsp" },
          },
          -- Screen coordinates of the command line
          cmdline_position = function()
            if lazy_utils.has "noice.nvim" then
              local Api = require "noice.api"
              local pos = Api.get_cmdline_position()
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                return { pos.screenpos.row - 1, pos.screenpos.col - 2 }
              end
              return { pos.screenpos.row, pos.screenpos.col - 1 }
            end
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
              return { pos[1] - 1, pos[2] }
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
        },
        list = {
          max_items = 100,
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            min_width = 15,
            max_height = 20,
            border = "rounded",
          },
          -- NOTE: improve perf
          -- treesitter_highlighting = false,
        },
        ghost_text = {
          enabled = true,
        },
      },
      -- experimental signature help support
      signature = {
        enabled = true,
        trigger = {
          -- buggy
          show_on_insert = false,
        },
        window = {
          min_width = 15,
          max_height = 20,
          border = "rounded",
          -- TODO: fix scrollbar position
          -- scrollbar = true,
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      sources = {
        defaults = {
          -- Dynamically picking providers by treesitter node/filetype
          function()
            if blink_cmp_utils.inside_comment_block() then
              return { "buffer" }
            end
            return nil
          end,
        },
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            -- if lsp takes more than 500ms then make it async
            timeout_ms = 500,
            score_offset = 0,
            fallbacks = {},
            opts = {
              tailwind_color_icon = icons_constants.other.color,
            },
          },
          snippets = {
            max_items = 10,
            -- NOTE: kind doesn't exists in blink.cmp
            kind = "Snippet",
            score_offset = 0,
          },
          buffer = {
            max_items = 10,
            score_offset = -10,
          },
          path = {
            max_items = 10,
            score_offset = 20,
            fallbacks = {},
          },
          cmdline = {
            max_items = 10,
            score_offset = 0,
          },
          cmdline_history_cmd = {
            name = "cmdline_history",
            module = "blink.compat.source",
            max_items = 5,
            score_offset = -20,
            opts = {
              history_type = "cmd",
            },
            kind = "History",
          },
          cmdline_history_search = {
            name = "cmdline_history",
            module = "blink.compat.source",
            max_items = 5,
            score_offset = -20,
            opts = {
              history_type = "search",
            },
            kind = "History",
          },
        },
      },
      keymap = {
        preset = "none",
        ["<C-Space>"] = { "show" },
        ["<C-u>"] = {
          "scroll_documentation_up",
          function()
            return blink_cmp_utils.scroll_signature_up()
          end,
          "fallback",
        },
        ["<C-d>"] = {
          "scroll_documentation_down",
          function()
            return blink_cmp_utils.scroll_signature_down()
          end,
          "fallback",
        },
        ["<C-b>"] = {
          function(cmp)
            if not cmp.is_visible() then
              return
            end
            vim.schedule(function()
              blink_cmp_utils.select_next_idx(4, -1)
            end)
            return true
          end,
          "fallback",
        },
        ["<C-f>"] = {
          function(cmp)
            if not cmp.is_visible() then
              return
            end
            vim.schedule(function()
              blink_cmp_utils.select_next_idx(4)
            end)
            return true
          end,
          "fallback",
        },
        ["<C-p>"] = {
          function(cmp)
            if not cmp.is_visible() then
              cmp.show()
              return
            end
            cmp.select_prev()
          end,
        },
        ["<C-n>"] = {
          function(cmp)
            if not cmp.is_visible() then
              cmp.show()
              return
            end
            cmp.select_next()
          end,
        },
        ["<C-e>"] = {
          function()
            return blink_cmp_utils.hide_signature()
          end,
          "cancel",
          "fallback",
        },
        ["<C-y>"] = {
          function()
            -- insert undo breakpoint
            keymaps_utils.run_expr "<C-g>u"
          end,
          "select_and_accept",
        },
      },
      cmdline = {
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer", "cmdline_history_search" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline", "cmdline_history_cmd" }
          end
          return {}
        end,
        keymap = {
          preset = "none",
          ["<C-Space>"] = { "show" },
          ["<C-b>"] = {
            function(cmp)
              if not cmp.is_visible() then
                return
              end
              vim.schedule(function()
                blink_cmp_utils.select_next_idx(4, -1)
              end)
              return true
            end,
            "fallback",
          },
          ["<C-f>"] = {
            function(cmp)
              if not cmp.is_visible() then
                return
              end
              vim.schedule(function()
                blink_cmp_utils.select_next_idx(4)
              end)
              return true
            end,
            "fallback",
          },
          ["<C-p>"] = {
            function(cmp)
              if not cmp.is_visible() then
                cmp.show()
                return
              end
              cmp.select_prev()
            end,
          },
          ["<C-n>"] = {
            function(cmp)
              if not cmp.is_visible() then
                cmp.show()
                return
              end
              cmp.select_next()
            end,
          },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<C-y>"] = { "select_and_accept" },
          ["<C-S-y>"] = {
            function()
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "")
            end,
          },
          ["<Tab>"] = {
            function(cmp)
              if not cmp.is_visible() then
                cmp.show()
                return
              end
              cmp.select_next()
            end,
          },
          ["<S-Tab>"] = {
            function(cmp)
              if not cmp.is_visible() then
                cmp.show()
                return
              end
              cmp.select_prev()
            end,
          },
        },
        completion = {
          menu = {
            auto_show = true,
            draw = {
              -- gap = 2,
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "kind" },
              },
            },
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
          ghost_text = {
            enabled = false,
          },
        },
      },
    },
    config = function(_, opts)
      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1
          CompletionItemKind[kind_idx] = provider.kind
          CompletionItemKind[provider.kind] = kind_idx
          local transform_items = provider.transform_items
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end
          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      -- check for sources.defaults
      if opts.sources.defaults then
        local defaults = opts.sources.defaults
        local originalDefault = opts.sources.default
        opts.sources.default = function()
          for _, func in ipairs(defaults) do
            local result = func(originalDefault)
            if result ~= nil then
              return result
            end
          end
          return originalDefault
        end
        -- Unset custom prop
        opts.sources.defaults = nil
      end

      -- check for enableds
      if opts.enableds then
        local enableds = opts.enableds
        local originalEnabled = opts.enabled
        opts.enabled = function()
          for _, func in ipairs(enableds) do
            local result = func()
            if result ~= nil then
              return result
            end
          end
          return originalEnabled()
        end
        -- Unset custom prop
        opts.enableds = nil
      end

      require("blink.cmp").setup(opts)
    end,
  },
}
