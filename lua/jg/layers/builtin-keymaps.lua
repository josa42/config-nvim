local layer = require('jg.lib.layer')

layer.use({

  init = function()
    vim.g.mapleader = ' '
  end,

  map = {
    -- select tabs
    { 'n', '<Tab>', ':tabnext<CR>', noremap = true },
    { 'n', '<S-Tab>', ':tabprevious<CR>', noremap = true },

    -- move tabs
    { 'n', 'm<Tab>', ':tabm +1<CR>', noremap = true },
    { 'n', 'm<S-Tab>', ':tabm -1<CR>', noremap = true },

    -- move lines
    { 'n', 'g<up>', ':m -2<cr>', noremap = true },
    { 'n', 'g<down>', ':m +1<cr>', noremap = true },
    { 'v', 'g<up>', ":m '<-2<CR>gv=gv", noremap = true },
    { 'v', 'g<down>', ":m '>+1<CR>gv=gv", noremap = true },

    -- redo
    { 'n', '<S-U>', '<C-R>', noremap = true },

    -- folds
    -- {
    --   'n',
    --   '<space><space>',
    --   [[:exe 'silent! normal! '.((foldclosed('.')>0)? 'zMzx' : 'zc')<CR>]],
    --   noremap = true,
    -- },

    -- Navigate panes
    { '', '<C-Down>', '<C-W><C-J>', noremap = true },
    { '', '<C-Up>', '<C-W><C-K>', noremap = true },
    { '', '<C-Right>', '<C-W><C-L>', noremap = true },
    { '', '<C-Left>', '<C-W><C-H>', noremap = true },

    { '', '<Leader><Down>', '<C-W><C-J>', noremap = true },
    { '', '<Leader><Up>', '<C-W><C-K>', noremap = true },
    { '', '<Leader><Right>', '<C-W><C-L>', noremap = true },
    { '', '<Leader><Left>', '<C-W><C-H>', noremap = true },

    -- Search
    { 'n', '/', '/\\v', noremap = true },
    { 'v', '/', '/\\v', noremap = true },
    { 'c', '%s/', '%s/\\v', noremap = true },

    -- Deleting without yanking
    { 'n', 'c', '"_c', noremap = true },
    { 'x', 'c', '"_c', noremap = true },
    { 'n', 'cc', '"_S', noremap = true },
    { 'n', 'C', '"_C', noremap = true },
    { 'x', 'C', '"_C', noremap = true },
    { 'n', 's', '"_s', noremap = true },
    { 'x', 's', '"_s', noremap = true },
    { 'n', 'S', '"_S', noremap = true },
    { 'x', 'S', '"_S', noremap = true },
    { 'n', 'd', '"_d', noremap = true },
    { 'x', 'd', '"_d', noremap = true },
    { 'n', 'dd', '"_dd', noremap = true },
    { 'n', 'D', '"_D', noremap = true },
    { 'x', 'D', '"_D', noremap = true },

    -- paste without yanking
    { 'v', 'p', '"0p', noremap = true },
    { 'v', 'P', '"0P', noremap = true },

    -- use x for copy
    { 'n', 'x', 'd', noremap = true },
    { 'x', 'x', 'd', noremap = true },
    { 'n', 'xx', 'dd', noremap = true },
    { 'n', 'X', 'D', noremap = true },
    { 'x', 'X', 'D', noremap = true },

    -- List navigation
    { 'n', '<c-j>', ':cnext<CR>zz', noremap = true },
    { 'n', '<c-k>', ':cprevious<CR>zz', noremap = true },

    -- show hilight group
    -- vim.cmd([[map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'<cr>]])

    -- Keep cursor centered: next or previews search result
    { 'n', 'n', 'nzzzv', noremap = true },
    { 'n', 'N', 'Nzzzv', noremap = true },

    -- Keep cursor centered: joining lines
    { 'n', 'J', 'mzJ`z', noremap = true },
  },
})
