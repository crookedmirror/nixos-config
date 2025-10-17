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
      -- TODO: remove once got rid of bloated LazyVim
      opts.ensure_installed = { "toml", "lua"  }
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
}
