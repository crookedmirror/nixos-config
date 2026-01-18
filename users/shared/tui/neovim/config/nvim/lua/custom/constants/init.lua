local lang_utils = require "custom.utils.lang"

local M = {}

M.width_fullscreen = 174
M.height_fullscreen = 0.9

M.zindex_fullscreen = 49
M.zindex_float = 43

M.text_filetypes = {
  "gitcommit",
  "gitrebase",
  "markdown",
  "tex",
  "bib",
  "typst",
  "",
}

local common_exclude_filetypes = {
  "neo-tree",
  "DiffviewFileHistory",
  "DiffviewFiles",
  "blame",
  "trouble",
  "dap-repl",
  "dap-view",
  "dap-view-term",
  "lazy",
  "mason",
  "wk",
  "noice",
  "harpoon",
  "Avante",
  "AvanteInput",
  "AvanteSelectedFiles",
  "incline",
  "snacks_picker_input",
  "snacks_picker_list",
  "snacks_picker_preview",
  "fidget",
  "qf",
  "notify",
  "terminal",
  "netrw",
  "tutor",
}

M.window_picker_exclude_filetypes = lang_utils.list_merge(common_exclude_filetypes, {
  "treesitter_context",
})

M.exclude_filetypes = lang_utils.list_merge(common_exclude_filetypes, {
  "lspinfo",
  "leetcode.nvim",
  "oil",
  "grug-far",
  "grug-far-history",
  "grug-far-help",
  "spectre_panel",
  "checkhealth",
  "help",
  "vim",
})

M.window_picker_exclude_buftypes = {
  "terminal",
  "nofile",
  "prompt",
}

M.exclude_buftypes = lang_utils.list_merge(M.window_picker_exclude_buftypes, {
  "help",
})

M.in_foot = os.getenv "TERM" == "foot"

M.in_kitty = false

M.in_neovide = vim.g.neovide

M.in_zk = os.getenv "IN_ZK" == "true"

M.in_obsidian = os.getenv "IN_OBSIDIAN" == "true"

local leet_arg = "leetcode.nvim"
M.in_leetcode = leet_arg == vim.fn.argv()[1]

M.in_kittyscrollback = false

M.has_file_arg = vim.fn.argc(-1) > 0

M.transparent_background = os.getenv "TRANSPARENT" == "true" and true or false

M.blur_background = os.getenv "BLUR" == "true" and true or false

M.first_install = false

local es_spell_path = vim.fn.stdpath "data" .. "/site/spell/es.utf-8.spl"
M.disable_netrw = vim.uv.fs_stat(es_spell_path) and true or false

M.big_file_mb = 0.5

local nix_path = os.getenv "NIX_PATH"
M.in_nix = nix_path ~= nil and nix_path ~= ""

M.in_lite = os.getenv "LITE" == "true"

M.in_vi_edit = os.getenv "IN_VI_EDIT" == "true"

return M
