vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.g.mapleader = " "

vim.opt.statuscolumn = "%s%{v:lnum} "
vim.opt.cursorline = true

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

require("config.lazy")

vim.cmd.colorscheme('kanagawa-wave')
