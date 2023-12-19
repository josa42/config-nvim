vim.opt.showmode = false
vim.opt.cmdheight = 1

vim.opt.cursorline = true

vim.opt.mouse = 'n'

-- font
vim.g.nerdfont = true
vim.opt.guifont = 'DejaVuSansMono Nerd Font:h12'

-- Do not write .swp files
vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.updatetime = 300
vim.opt.hidden = true

vim.opt.autochdir = false

-- Scroll offset
vim.opt.scrolloff = 2

-- pum
vim.opt.pumblend = 0
vim.opt.pumheight = 12
vim.opt.wildoptions = 'pum'
vim.opt.shortmess:append('c')

-- Persistent undo
vim.opt.undodir = vim.fs.joinpath(vim.fn.stdpath('data'), 'undo')
vim.opt.undofile = true

--Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'topline'

-- search
vim.opt.hlsearch = true -- Highlight search results.
vim.opt.ignorecase = false -- Make searching case insensitive
vim.opt.smartcase = true -- ... unless the query has capital letters.
vim.opt.gdefault = true -- Use 'g' flag by default with :s/foo/bar/.
vim.opt.magic = true -- Use 'magic' patterns (extended regular expressions).

vim.opt.incsearch = true -- Incremental search.
vim.opt.inccommand = 'split'

vim.opt.wildignore = {
  '.sass-cache',
  '.DS_Store',
  '.git$',
  '~$',
  '.swp$',
  'gin-bin',
  '*/node_modules/*',
}

-- indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.linebreak = true

-- folds
vim.opt.foldmethod = 'marker'
vim.opt.foldenable = true
vim.opt.foldlevel = 0
vim.opt.foldmarker = { '#region', '#endregion' }
vim.opt.fillchars = { eob = ' ', fold = ' ', foldopen = '', foldsep = ' ', foldclose = '' }

-- status column
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = 'yes'
vim.opt.foldcolumn = 'auto:5'
vim.opt.statuscolumn = vim.fn.join({
  -- signs
  '%s',
  -- line number
  '%=%{&nu&&(!v:virtnum)? (&rnu&&(v:relnum) ? v:relnum : v:lnum." ") : ""} ',
  -- fold
  '%C%',
  -- space
  '#Normal#%{&nu? " " : ""}',
}, '')
