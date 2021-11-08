local plug = require('jg.lib.plug')
local map = vim.api.nvim_set_keymap

plug.require('christoomey/vim-tmux-navigator')

vim.g.tmux_navigator_no_mappings = 1

map('n', '<C-Left>',  ':TmuxNavigateLeft<cr>',     { noremap = true, silent = true})
map('n', '<C-Down>',  ':TmuxNavigateDown<cr>',     { noremap = true, silent = true })
map('n', '<C-Up>',    ':TmuxNavigateUp<cr>',       { noremap = true, silent = true })
map('n', '<C-Right>', ':TmuxNavigateRight<cr>',    { noremap = true, silent = true })
-- map('n', '<C-.>',     ':TmuxNavigatePrevious<cr>', { noremap = true, silent = true })

