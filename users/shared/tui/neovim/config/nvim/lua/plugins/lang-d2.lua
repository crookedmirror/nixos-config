return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "d2" },
    },
  },
  {
    "ravsii/tree-sitter-d2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    build = "make nvim-install",
  },
  {
    "kentchiu/d2.nvim",
    ft = "d2",
    config = function()
      require("d2").setup()
    end,
  },
}
