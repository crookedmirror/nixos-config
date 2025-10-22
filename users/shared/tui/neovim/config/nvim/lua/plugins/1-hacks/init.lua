-- HACK: this file will be loaded first by lazy.nvim
-- NOTE: `opts_extend` don't work as expected
-- if it isn't read by `lazy.nvim` at the start

return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts_extend = { "ensure_installed" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts_extend = { "ensure_installed" },
  },
}
