local map = vim.keymap.set

map('n', '<C-h>', '<C-w>h', { desc = "Window Left" })
map('n', '<C-l>', '<C-w>l', { desc = "Window Right" })
map('n', '<C-j>', '<C-w>j', { desc = "Window Down" })
map('n', '<C-k>', '<C-w>k', { desc = "Window Up" })

map('n', '<leader>w', ':w<CR>', { desc = "Save" })
map('n', '<leader>q', ':q<CR>', { desc = "Quit" })

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Limpiar búsqueda" })