return {
  {
    "ravsii/tree-sitter-d2",
    ft = "d2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    build = "make nvim-install",
    config = function()
      require("tree-sitter-d2").setup()
    end,
  },
  {
    "kentchiu/d2.nvim",
    ft = "d2",
    config = function()
      require("d2").setup()
    end,
  },
}
