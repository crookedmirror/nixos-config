vim.cmd.syntax("manual")

vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

-- leave the job to treesitter
require("config/options")
require("config/lazy")
require("config/autocmds")
