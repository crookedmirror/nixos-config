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
      opts.ensure_installed = { "toml" }
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
}
