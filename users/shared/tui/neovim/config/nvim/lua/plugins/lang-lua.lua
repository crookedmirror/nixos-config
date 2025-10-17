return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = { "lua" },
    },
  },
}
