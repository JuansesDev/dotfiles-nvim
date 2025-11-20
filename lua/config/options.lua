vim.g.mapleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.mouse = "a"

-- Indentación
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Comportamiento
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.scrolloff = 4

-- Busqueda de archivos nativa mejorada
vim.opt.path:append("**")
vim.opt.wildignore = "*/node_modules/**"
vim.o.wildignorecase = true