local layer = require('jg.lib.layer')

layer.use({

  init = function()
    vim.g.mapleader = ' '
  end,

  map = {
    -- Navigate panes
    { '', '<C-Down>', '<C-W><C-J>', 'Focus Pane Below' },
    { '', '<C-Up>', '<C-W><C-K>', 'Focus Pane Above' },
    { '', '<C-Right>', '<C-W><C-L>', 'Focus Pane Right' },
    { '', '<C-Left>', '<C-W><C-H>', 'Focus Pane Left' },

    -- Search
    -- { 'n', '/', '/\\v' },
    -- { 'v', '/', '/\\v' },
    -- { 'c', '%s/', '%s/\\v' },

    -- Deleting without yanking
    { 'n', 'c', '"_c' },
    { 'x', 'c', '"_c' },
    { 'n', 'cc', '"_S' },
    { 'n', 'C', '"_C' },
    { 'x', 'C', '"_C' },
    { 'n', 's', '"_s' },
    { 'x', 's', '"_s' },
    { 'n', 'S', '"_S' },
    { 'x', 'S', '"_S' },
    { 'n', 'd', '"_d' },
    { 'x', 'd', '"_d' },
    { 'n', 'dd', '"_dd' },
    { 'n', 'D', '"_D' },
    { 'x', 'D', '"_D' },

    -- paste without yanking
    { 'v', 'p', '"0p' },
    { 'v', 'P', '"0P' },

    -- use x for copy
    { 'n', 'x', 'd' },
    { 'x', 'x', 'd' },
    { 'n', 'xx', 'dd' },
    { 'n', 'X', 'D' },
    { 'x', 'X', 'D' },

    -- List navigation
    { 'n', '<c-j>', ':cnext<CR>zz' },
    { 'n', '<c-k>', ':cprevious<CR>zz' },

    -- Keep cursor centered: next or previews search result
    { 'n', 'n', 'nzzzv' },
    { 'n', 'N', 'Nzzzv' },

    -- Keep cursor centered: joining lines
    { 'n', 'J', 'mzJ`z' },

    { 'n', 'j', "v:count == 0 ? 'gj' : 'j'", expr = true },
    { 'n', 'k', "v:count == 0 ? 'gk' : 'k'", expr = true },

    -- Nop arrow keys
    { '', '<Up>', '<nop>' },
    { '', '<Right>', '<nop>' },
    { '', '<Down>', '<nop>' },
    { '', '<Left>', '<nop>' },

    { 'i', '<c-k>', '<Up>' },
    { 'i', '<c-l>', '<Right>' },
    { 'i', '<c-j>', '<Down>' },
    { 'i', '<c-h>', '<Left>' },
  },
})
