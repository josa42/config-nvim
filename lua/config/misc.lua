vim.opt.showmode = false
vim.opt.cmdheight = 1

vim.opt.cursorline = true

vim.opt.mouse = 'n'

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

vim.g.nerdfont = true
