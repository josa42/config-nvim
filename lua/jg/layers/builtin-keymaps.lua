local map = vim.api.nvim_set_keymap

vim.g.mapleader = " "

-- select tabs
map('n', '<Tab>',   ':tabnext<CR>',     { noremap = true, silent = true })
map('n', '<S-Tab>', ':tabprevious<CR>', { noremap = true, silent = true })

-- move tabs
map('n', 'm<Tab>',   ':tabm +1<CR>', { noremap = true, silent = true })
map('n', 'm<S-Tab>', ':tabm -1<CR>', { noremap = true, silent = true })

-- move lines
map('n', 'g<up>',    ':m -2<cr>',          { noremap = true })
map('n', 'g<down>',  ':m +1<cr>',          { noremap = true })
map('v', 'g<up>',    ":m '<-2<CR>gv=gv",   { noremap = true })
map('v', 'g<down>',  ":m '>+1<CR>gv=gv",   { noremap = true })

-- redo
map('n', '<S-U>', '<C-R>', { noremap = true })

-- TODO move to lsp?
-- Navigation completions with <s-tab>
map('i', '<S-TAB>', [[
  pumvisible() ? "\<C-p>" : "\<C-h>"
]], { silent = true, expr = true, noremap = true })

-- folds
map('n', '<space><space>', [[:exe 'silent! normal! '.((foldclosed('.')>0)? 'zMzx' : 'zc')<CR>]], { noremap = true, silent = true })

-- Navigate panes
map('', '<C-Down>',  '<C-W><C-J>', { noremap = true })
map('', '<C-Up>',    '<C-W><C-K>', { noremap = true })
map('', '<C-Right>', '<C-W><C-L>', { noremap = true })
map('', '<C-Left>',  '<C-W><C-H>', { noremap = true })

map('', '<Leader><Down>',  '<C-W><C-J>', { noremap = true })
map('', '<Leader><Up>',    '<C-W><C-K>', { noremap = true })
map('', '<Leader><Right>', '<C-W><C-L>', { noremap = true })
map('', '<Leader><Left>',  '<C-W><C-H>', { noremap = true })

-- Search
map('n', '/',   '/\\v',   { noremap = true })
map('v', '/',   '/\\v',   { noremap = true })
map('c', '%s/', '%s/\\v', { noremap = true })

-- Map Ctrl+l to clear highlighted searches
map('n', '<C-l>', ':<C-u>nohlsearch<CR><C-l>', { noremap = true, silent = true })

-- Deleting without yanking
map('n', 'c',  '"_c',  { noremap = true })
map('x', 'c',  '"_c',  { noremap = true })
map('n', 'cc', '"_S',  { noremap = true })
map('n', 'C',  '"_C',  { noremap = true })
map('x', 'C',  '"_C',  { noremap = true })
map('n', 's',  '"_s',  { noremap = true })
map('x', 's',  '"_s',  { noremap = true })
map('n', 'S',  '"_S',  { noremap = true })
map('x', 'S',  '"_S',  { noremap = true })
map('n', 'd',  '"_d',  { noremap = true })
map('x', 'd',  '"_d',  { noremap = true })
map('n', 'dd', '"_dd', { noremap = true })
map('n', 'D',  '"_D',  { noremap = true })
map('x', 'D',  '"_D',  { noremap = true })

-- paste without yanking
map('v', 'p', '"0p', { noremap = true })
map('v', 'P', '"0P', { noremap = true })

-- use x for copy
map('n', 'x',  'd',  { noremap = true })
map('x', 'x',  'd',  { noremap = true })
map('n', 'xx', 'dd', { noremap = true })
map('n', 'X',  'D',  { noremap = true })
map('x', 'X',  'D',  { noremap = true })

-- List navigation
map('n', 'gn', ':cnext<CR>', { noremap = true })
map('n', 'gp', ':cprevious<CR>', { noremap = true })

-- show hilight group
vim.cmd([[map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'<cr>]])

