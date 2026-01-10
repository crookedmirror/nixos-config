vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.cmd.syntax("manual")

vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

require("config/options")
require("config/lazy")
require("config/autocmds")
