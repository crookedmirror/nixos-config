local constants = require "constants"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.yaml",
  },

  -- NOTE: lang-web.lua adds Prettier formatting for Markdown
 
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "yaml",
      },
    },
  },
}
