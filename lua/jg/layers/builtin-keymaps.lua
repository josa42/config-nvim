local layer = require('jg.lib.layer')

layer.use({

  init = function()
    vim.g.mapleader = ' '
  end,

  map = {
    -- select tabs
    { 'n', '<Tab>', ':tabnext<CR>', desc = 'Select Next Tab' },
    { 'n', '<S-Tab>', ':tabprevious<CR>', desc = 'Select Previous Tab' },

    -- move tabs
    { 'n', 'm<Tab>', ':tabm +1<CR>', desc = 'Move Tab Right' },
    { 'n', 'm<S-Tab>', ':tabm -1<CR>', desc = 'Move Tab Left' },

    -- move lines
    { 'n', 'g<up>', ':m -2<cr>', desc = 'Move Line Up' },
    { 'n', 'g<down>', ':m +1<cr>', desc = 'Move Line Down' },
    { 'v', 'g<up>', ":m '<-2<CR>gv=gv", desc = 'Move Selection Up' },
    { 'v', 'g<down>', ":m '>+1<CR>gv=gv", desc = 'Move Selection Down' },

    -- redo
    { 'n', '<S-U>', '<C-R>', desc = 'Redo' },

    {
      'n',
      '<space>h',
      function()
        local syn_id = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1)
        local syn_id_trans = vim.fn.synIDtrans(syn_id)
        print(('hi %s -> %s'):format(vim.fn.synIDattr(syn_id, 'name'), vim.fn.synIDattr(syn_id_trans, 'name')))
      end,
      desc = 'Show Hightlight Group',
    },

    -- Navigate panes
    { '', '<C-Down>', '<C-W><C-J>', 'Focus Pane Below' },
    { '', '<C-Up>', '<C-W><C-K>', 'Focus Pane Above' },
    { '', '<C-Right>', '<C-W><C-L>', 'Focus Pane Right' },
    { '', '<C-Left>', '<C-W><C-H>', 'Focus Pane Left' },

    -- Search
    { 'n', '/', '/\\v' },
    { 'v', '/', '/\\v' },
    { 'c', '%s/', '%s/\\v' },

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

    -- toggle spell checker
    {
      { 'n', 'i' },
      '<c-s>',
      function()
        vim.wo.spell = not vim.wo.spell
      end,
      desc = 'Toggle Spell Checking',
    },
  },
})
