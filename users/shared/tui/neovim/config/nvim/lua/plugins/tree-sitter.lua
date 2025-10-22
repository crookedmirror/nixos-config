local lazy_utils = require "utils.lazy"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = function()
      local TS = require "nvim-treesitter"
      TS.update(nil, { summary = true })
    end,
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    opts = function(_, opts)
      -- Replace LazyVim's ensure_installed with our own list
      opts.ensure_installed = {
        "toml",
        -- everything below is from plugins/lang-*.lua
        -- TODO: remove once got rid of bloated LazyVim
        -- NOTE: maybe there is chance to override it at the start of LazyVim
        "d2",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "bash",
        "just",
        "yaml",
      }
      return opts
    end,
    config = function(_, opts)
      local TS = require "nvim-treesitter"
      local TSUtils = require "utils-plugins.treesitter"

      TS.setup(opts)
      TSUtils.get_installed(true)

      local install = vim.tbl_filter(function(lang)
        return not TSUtils.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          TSUtils.get_installed(true)
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
        callback = function(ev)
          if not TSUtils.have(ev.match) then
            return
          end

          -- highlighting
          pcall(vim.treesitter.start)

          -- indents; quick, using '='
          if TSUtils.have(ev.match, "indents") then
            local exclude_filetypes = { "lua" }
            if not vim.tbl_contains(exclude_filetypes, ev.match) then
              vim.bo.indentexpr = [[%!v:lua.require('utils-plugins.treesitter').indentexpr()]]
            end
          end

          -- folds
          if TSUtils.have(ev.match, "folds") then
            vim.wo.foldexpr = [[!v:lua.require('utils-plugins.treesitter').foldexpr()]]
          end
        end,
      })

      vim.treesitter.language.register("bash", "zsh")

      -- add toggle keymap for treesitter
      Snacks.toggle.treesitter():map "<leader>uT"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        keys = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      local TS = require "nvim-treesitter-textobjects"
      TS.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("lazyvim_treesitter_textobjects", { clear = true }),
        callback = function(ev)
          if not (vim.tbl_get(opts, "move", "enable") and LazyVim.treesitter.have(ev.match, "textobjects")) then
            return
          end
          local moves = vim.tbl_get(opts, "move", "keys") or {}

          for method, keymaps in pairs(moves) do
            for key, query in pairs(keymaps) do
              local desc = query:gsub("@", ""):gsub("%..*", "")
              desc = desc:sub(1, 1):upper() .. desc:sub(2)
              desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
              desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
              if not (vim.wo.diff and key:find "[cC]") then
                vim.keymap.set({ "n", "x", "o" }, key, function()
                  require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
                end, {
                  buffer = ev.buf,
                  desc = desc,
                  silent = true,
                })
              end
            end
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    keys = {
      {
        "gC",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        mode = "n",
        desc = "GoTo Context",
      },
    },
    opts = function()
      local tsc = require "treesitter-context"
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map "<leader>ut"

      return {
        mode = "cursor",
        max_lines = 3,
        zindex = 43,
        line_numbers = true,
        enable_hl = false,
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "InsertEnter", "VeryLazy" },
    config = function()
      lazy_utils.on_load("nvim-treesitter", function()
        require("nvim-ts-autotag").setup()
      end)
    end,
  },
  {
    "aaronik/treewalker.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<A-j>",
        "<cmd>Treewalker Down<CR>",
        mode = { "n", "v" },
        desc = "Treewalker Down",
      },
      {
        "<A-k>",
        "<cmd>Treewalker Up<CR>",
        mode = { "n", "v" },
        desc = "Treewalker Up",
      },
      {
        "<A-h>",
        "<cmd>Treewalker Left<CR>",
        mode = { "n", "v" },
        desc = "Treewalker Left",
      },
      {
        "<A-l>",
        "<cmd>Treewalker Right<CR>",
        mode = { "n", "v" },
        desc = "Treewalker Right",
      },
    },
    opts = {
      highlight = true,
      highlight_duration = 100,
      highlight_group = "Highlight",
    },
  },
}
