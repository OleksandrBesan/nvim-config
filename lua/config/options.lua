-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "
vim.g.maplocalleader = ";"
vim.opt.termguicolors = true
vim.o.switchbuf = "useopen,usetab"

vim.api.nvim_command("set conceallevel=0")
vim.g.autoformat = false -- global autoformat enabled