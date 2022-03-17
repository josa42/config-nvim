require('jg.lib.polyfills')
local paths = require('jg.lib.paths')

vim.opt.number = true -- Show: Line numbers
vim.opt.cursorline = true -- Hilight current curser line
vim.opt.showmode = false -- Hide: -- INSERT --

-- Editing
vim.opt.listchars = 'tab:» ,extends:›,precedes:‹,nbsp:·,space:·,trail:·'
vim.opt.list = true -- Show white space
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.colorcolumn = { 80, 120 }

vim.opt.mouse = 'a'

vim.opt.guifont = 'DejaVuSansMono Nerd Font'

-- clipboard
vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'

-- Do not write .swp files
vim.opt.backup = false
vim.opt.swapfile = false

-- Persistent undo
vim.opt.undodir = paths.dataDir .. '/undo'
vim.opt.undofile = true

vim.opt.conceallevel = 2

vim.opt.cmdheight = 1 -- Better display for messages
vim.opt.shortmess = vim.opt.shortmess + 'c' -- don't give |ins-completion-menu| messages.
vim.opt.signcolumn = 'yes' -- always show signcolumns
vim.opt.updatetime = 300 -- Smaller updatetime for CursorHold & CursorHoldI
vim.opt.hidden = true -- if hidden is not set, TextEdit might fail.

-- Spell check
vim.opt.spell = true
vim.opt.spelllang = { 'en_gb', 'en_us', 'de_20' }

--Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
--
-- Theme
-- TODO what is this?
vim.cmd([[ let $NVIM_TUI_ENABLE_TRUE_COLOR = 1 ]])

-- Search
vim.opt.hlsearch = true -- Highlight search results.
vim.opt.ignorecase = false -- Make searching case insensitive
vim.opt.smartcase = true -- ... unless the query has capital letters.
vim.opt.gdefault = true -- Use 'g' flag by default with :s/foo/bar/.
vim.opt.magic = true -- Use 'magic' patterns (extended regular expressions).
vim.opt.foldmethod = 'marker'
vim.opt.foldenable = true

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

vim.opt.autochdir = false

-- Always draw the signcolumn.
vim.opt.signcolumn = 'yes'

vim.opt.autoread = true

local autoread_group = vim.api.nvim_create_augroup('jg.autoread', { clear = true })
-- read files on focus
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, { command = 'silent! !', group = autoread_group })
-- save on focus lost!
vim.api.nvim_create_autocmd({ 'FocusLost', 'WinLeave' }, { command = 'silent! update', group = autoread_group })
-- ignore removed files
vim.api.nvim_create_autocmd({ 'FileChangedShell' }, { command = 'execute', group = autoread_group })

-- Scroll offset
vim.opt.scrolloff = 2

-- pum
vim.opt.pumblend = 0
vim.opt.wildoptions = 'pum'

vim.g.nerdfont = true

local settings_group = vim.api.nvim_create_augroup('jg.language_settings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = settings_group,
  pattern = 'yaml',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  group = settings_group,
  pattern = 'markdown',
  callback = function()
    vim.wo.wrap = true
  end,
})

local paste_group = vim.api.nvim_create_augroup('jg.paste', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWrite', 'InsertLeave' }, {
  group = paste_group,
  callback = function()
    vim.o.paste = false
  end,
})

local yank_group = vim.api.nvim_create_augroup('jg.yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = yank_group,
  callback = require('vim.highlight').on_yank,
})
