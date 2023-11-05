vim.g.mapleader = ' '

vim.keymap.set('n', 'U', '<C-r>')

-- Nop arrow keys
vim.keymap.set('', '<Up>', '<nop>')
vim.keymap.set('', '<Right>', '<nop>')
vim.keymap.set('', '<Down>', '<nop>')
vim.keymap.set('', '<Left>', '<nop>')

vim.keymap.set('i', '<c-k>', '<Up>')
vim.keymap.set('i', '<c-l>', '<Right>')
vim.keymap.set('i', '<c-j>', '<Down>')
vim.keymap.set('i', '<c-h>', '<Left>')

-- Navigate panes
vim.keymap.set('', '<C-Down>', '<C-W><C-J>', { desc = 'Focus Pane Below' })
vim.keymap.set('', '<C-Up>', '<C-W><C-K>', { desc = 'Focus Pane Above' })
vim.keymap.set('', '<C-Right>', '<C-W><C-L>', { desc = 'Focus Pane Right' })
vim.keymap.set('', '<C-Left>', '<C-W><C-H>', { desc = 'Focus Pane Left' })

vim.keymap.set('n', '<leader><space>', '<c-w><c-p>', { silent = true })
vim.keymap.set('n', '<Down>', '<C-W><C-J>', { desc = 'Focus Pane Below' })
vim.keymap.set('n', '<Up>', '<C-W><C-K>', { desc = 'Focus Pane Above' })
vim.keymap.set('n', '<Right>', '<C-W><C-L>', { desc = 'Focus Pane Right' })
vim.keymap.set('', '<Left>', '<C-W><C-H>', { desc = 'Focus Pane Left' })

-- Search
-- vim.keymap.set('n', '/', '/\\v')
-- vim.keymap.set('v', '/', '/\\v')
-- vim.keymap.set('c', '%s/', '%s/\\v')

-- Deleting without yanking
vim.keymap.set('n', 'c', '"_c')
vim.keymap.set('x', 'c', '"_c')
vim.keymap.set('n', 'cc', '"_S')
vim.keymap.set('n', 'C', '"_C')
vim.keymap.set('x', 'C', '"_C')
vim.keymap.set('n', 's', '"_s')
vim.keymap.set('x', 's', '"_s')
vim.keymap.set('n', 'S', '"_S')
vim.keymap.set('x', 'S', '"_S')
vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('x', 'd', '"_d')
vim.keymap.set('n', 'dd', '"_dd')
vim.keymap.set('n', 'D', '"_D')
vim.keymap.set('x', 'D', '"_D')

-- paste without yanking
vim.keymap.set('v', 'p', '"0p')
vim.keymap.set('v', 'P', '"0P')

-- use x for copy
vim.keymap.set('n', 'x', 'd')
vim.keymap.set('x', 'x', 'd')
vim.keymap.set('n', 'xx', 'dd')
vim.keymap.set('n', 'X', 'D')
vim.keymap.set('x', 'X', 'D')

-- List navigation
vim.keymap.set('n', '<c-j>', ':cnext<CR>zz')
vim.keymap.set('n', '<c-k>', ':cprevious<CR>zz')

-- Keep cursor centered: next or previews search result
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Keep cursor centered: joining lines
-- vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
