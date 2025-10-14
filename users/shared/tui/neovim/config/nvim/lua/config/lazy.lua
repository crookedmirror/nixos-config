local lazy_utils = require "config.utils.lazy"
local lazyvim_utils = require "config.utils.lazyvim"

lazy_utils.install()

lazyvim_utils.load()

require("lazy").setup({
  spec = {
    {
      "folke/lazy.nvim",
      version = "*",
    },  
    {
      "LazyVim/LazyVim",
      lazy = false,
      version = false,
      commit = "b4606f9df3395a261bb6a09acc837993da5d8bfc",
      priority = 10000,
      config = function()
	lazyvim_utils.setup()
      end,
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {},
      config = function(_, opts)
	local notify = vim.notify
	require("snacks").setup(opts)
	if lazy_utils.has "noice.nvim" then
	  vim.notify = notify
        end
      end,
    },
    { import = "config.plugins" },
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
})
