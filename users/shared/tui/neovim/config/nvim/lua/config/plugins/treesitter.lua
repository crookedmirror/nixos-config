return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    -- main has recent version of code
    branch = "main",   
    build = function()
	local treesitter = require "nvim-treesitter"
	treesitter.update(nil, { summary = true })
    end,
    event = { "LazyFile", "VeryLazy" },
    opts_extend = { "ensure_installed" },
    opts = {
      hisghlight = { enable = true },	    
    },
    cmd = { "TSUpdate", "TSInstall", "TSInstallFromGrammar", "TSLog", "TSUninstall" },
    config = function(_, opts)
      local treesitter = require "nvim-treesitter"
      local treesitter_utils = require "lazyvim.util.treesitter"
      treesitter.setup(opts)
      treesitter_utils.get_installed(true) -- initialize the installed langs

      local install = vim.tbl_filter(function(lang)
	return not treesitter_utils.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
	treesitter.install(install, { summary = true }):await(function()
	  treesitter_utils.get_installed(true) -- refresh the installed langs
	end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
	callback = function(ev)
	  if not treesitter_utils.have(ev.match) then
	    return
	  end
	  pcall(vim.treesitter.start)
        end,
      })

      vim.treesitter.language.register("bash", "zsh")
      Snacks.toggle.treesitter():map "<leader>uT"
    end,
  },
}
