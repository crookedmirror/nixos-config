local icons_constants = require "constants.icons"

-- Exclude filetypes for various UI plugins
local exclude_filetypes = {
  "neo-tree",
  "Trouble",
  "trouble",
  "lazy",
  "mason",
  "notify",
  "toggleterm",
  "lazyterm",
  "help",
  "qf",
  "snacks_dashboard",
}

return {
  -- Which-key (keybinding hints)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.timeout = true
    end,
    opts_extend = { "spec", "icons.rules" },
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>m", group = "misc" },
          { "<leader><Tab>", group = "tab" },
          { "<leader>b", group = "buffer" },
          { "<leader>u", group = "ui" },
          { "<leader>f", group = "find/search/replace" },
          { "<leader>g", group = "git" },
          { "<leader>c", group = "code" },
          { "<leader>p", group = "profiler" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "<leader>w", group = "windows" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
        },
      },
      preset = "modern",
      layout = {
        spacing = 0,
      },
      win = {
        no_overlap = false,
        title = false,
        padding = { 0, 1 },
      },
      icons = {
        rules = {
          { pattern = "paste", icon = " ", color = "azure" },
          { pattern = "comment", icon = " ", color = "grey" },
          { pattern = "lsp", icon = " ", color = "red" },
          { pattern = "misc", icon = " ", color = "orange" },
          { pattern = "trouble", icon = "󱖫 ", color = "yellow" },
          { pattern = "snip", icon = icons_constants.lsp_kind.Snippet .. " ", color = "orange" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show { keys = "<c-w>", loop = true }
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
  },

  -- Incline (floating filename per window)
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      ignore = {
        filetypes = exclude_filetypes,
      },
      hide = {
        focused_win = true,
        only_win = true,
      },
      window = {
        overlap = {
          borders = true,
        },
        zindex = 50,
        margin = {
          horizontal = 0,
          vertical = 1,
        },
      },
      render = function(props)
        local bufnr = props.buf
        local modified_indicator = " "
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
        local icon, _ = require("mini.icons").get("file", filename)
        if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
          modified_indicator = "  "
        end
        return { { " " .. icon .. " " }, { filename }, { modified_indicator } }
      end,
    },
  },

  -- Bufferline (wochap fork with element.id in get_element_icon)
  {
    "wochap/bufferline.nvim",
    branch = "main",
    event = "VeryLazy",
    keys = {
      {
        "<S-Right>",
        function()
          local bufferline = require "bufferline"
          pcall(bufferline.cycle, 1)
        end,
        desc = "Next Buffer",
      },
      {
        "<S-Left>",
        function()
          local bufferline = require "bufferline"
          pcall(bufferline.cycle, -1)
        end,
        desc = "Prev Buffer",
      },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      {
        "<leader><Tab>d",
        function()
          local ui = require "bufferline.ui"
          vim.cmd "tabclose"
          ui.refresh()
        end,
        desc = "Close Tab",
      },
    },
    init = function()
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    opts = {
      options = {
        themable = true,
        numbers = function(_opts)
          return string.format("%s", _opts.raise(_opts.ordinal))
        end,
        close_command = function(n)
          Snacks.bufdelete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        indicator = {
          style = "none",
        },
        modified_icon = "",
        left_trunc_marker = "❮",
        right_trunc_marker = "❯",
        diagnostics = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        get_element_icon = function(element)
          local icon, hl = require("mini.icons").get("file", vim.fn.fnamemodify(element.path, ":t"))
          if vim.api.nvim_get_current_buf() == element.id then
            return icon, hl
          end
          return icon, "DevIconDimmed"
        end,
        separator_style = { "", "" },
        always_show_bufferline = true,
        hover = { enabled = false },
        offsets = {},
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  -- Noice (wochap fork with fixed signature/hover window positions)
  {
    "wochap/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>n", "", desc = "noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Last Message",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "History",
      },
      {
        "<leader>na",
        function()
          require("noice").cmd "all"
        end,
        desc = "History All",
      },
      {
        "<leader>nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Dismiss All",
      },
      {
        "<c-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-u>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-d>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      cmdline = {
        enabled = true,
        format = {
          search_down = {
            view = "cmdline",
            icon = "  ",
          },
          search_up = {
            view = "cmdline",
            icon = "  ",
          },
        },
      },
      messages = {
        enabled = true,
        view_search = "virtualtext",
      },
      popupmenu = {
        enabled = false,
      },
      notify = {
        enabled = true,
        view = "mini",
      },
      lsp = {
        hover = {
          enabled = true,
        },
        signature = {
          enabled = false,
        },
        progress = {
          enabled = false,
        },
        message = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "yanked" },
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
        },
        {
          filter = {
            event = "msg_show",
            min_height = 20,
          },
          view = "cmdline_output",
        },
        {
          filter = {
            cmdline = "^:",
          },
          view = "cmdline_output",
        },
      },
      format = {
        level = {
          icons = {
            error = icons_constants.diagnostic.Error,
            warn = icons_constants.diagnostic.Warn,
            info = icons_constants.diagnostic.Info,
          },
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 4,
            col = "50%",
          },
          size = {
            min_width = 60,
            width = "auto",
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "NoiceCmdlinePopupNormal",
              FloatBorder = "NoiceCmdlinePopupBorder",
            },
          },
        },
        split = {
          enter = true,
        },
        mini = {
          position = {
            row = -1,
          },
          zindex = 50,
          win_config = {
            winblend = 100,
          },
        },
        hover = {
          size = {
            max_width = 90,
          },
          border = {
            style = "rounded",
            padding = {
              top = 0,
              bottom = 0,
              left = 0,
              right = 0,
            },
          },
          position = {
            row = 1,
            col = 1,
          },
          scrollbarOpts = {
            showBar = false,
            padding = {
              top = 1,
              bottom = 0,
              right = 1,
              left = 0,
            },
          },
        },
        confirm = {
          align = "top",
          position = {
            row = 4,
            col = "50%",
          },
          border = {
            text = {
              top = "",
            },
          },
        },
      },
    },
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd [[messages clear]]
      end
      require("noice").setup(opts)
    end,
  },

  -- Fidget (LSP progress)
  {
    "j-hui/fidget.nvim",
    tag = "v1.6.1",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
          zindex = 50,
        },
      },
      integration = {
        ["nvim-tree"] = {
          enable = false,
        },
        ["xcodebuild-nvim"] = {
          enable = false,
        },
      },
    },
  },

  -- Visual whitespace in visual mode
  {
    "mcauley-penney/visual-whitespace.nvim",
    enabled = false, -- Disabled by default like wochap
    event = "VeryLazy",
    opts = {
      highlight = { link = "VisualWhitespace" },
      space_char = "·",
      tab_char = "󰌒",
      nl_char = "",
      cr_char = "",
      excluded = {
        filetypes = exclude_filetypes,
        buftypes = { "nofile", "terminal", "prompt" },
      },
    },
  },

  -- Highlight colors (wochap fork with debounced highlighting)
  {
    "wochap/nvim-highlight-colors",
    event = "VeryLazy",
    opts = {
      render = "virtual",
      virtual_symbol = icons_constants.other.color,
      virtual_symbol_position = "eol",
      enable_named_colors = false,
      enable_tailwind = false,
      custom_colors = {},
      exclude_filetypes = { "", "bigfile" },
    },
  },

  -- Highlight undo/redo
  {
    "tzachar/highlight-undo.nvim",
    event = "VeryLazy",
    init = function()
      -- Highlight on yank
      vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
        callback = function()
          vim.highlight.on_yank { higroup = "Highlight", timeout = 100 }
        end,
      })
    end,
    opts = {
      duration = 100,
      hlgroup = "Highlight",
      ignored_filetypes = exclude_filetypes,
    },
  },

  -- Mini icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      default = {
        file = { glyph = "󰈤", hl = "MiniIconsRed" },
      },
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["README.md"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
        ["CONTRIBUTING.md"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
        ["robots.txt"] = { glyph = "󰚩", hl = "MiniIconsGrey" },
      },
      extension = {
        lock = { glyph = "󰌾", hl = "MiniIconsGrey" },
        ttf = { glyph = "", hl = "MiniIconsGrey" },
        woff = { glyph = "", hl = "MiniIconsGrey" },
        woff2 = { glyph = "", hl = "MiniIconsGrey" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Smear cursor (cursor animation)
  {
    "sphamba/smear-cursor.nvim",
    enabled = false, -- Disabled by default like wochap
    event = "VeryLazy",
    opts = {
      legacy_computing_symbols_support = true,
      smear_between_neighbor_lines = false,
      windows_zindex = 100,
    },
  },

  -- Modes (cursorline color based on mode)
  {
    "mvllow/modes.nvim",
    enabled = false, -- Enable if you want mode-based cursorline colors
    lazy = false,
    opts = {
      colors = {
        copy = "#f9e2af", -- yellow
        delete = "#f38ba8", -- red
        format = "#fab387", -- peach
        insert = "#a6e3a1", -- green
        replace = "#94e2d5", -- teal
        visual = "#cba6f7", -- mauve
      },
    },
  },

  -- Reactive (mode-based cursor/cursorline)
  {
    "rasulomaroff/reactive.nvim",
    enabled = false, -- Disabled by default like wochap
    event = "VeryLazy",
    opts = {},
  },

  -- Plenary (utility library)
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Nui (UI component library)
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
}
