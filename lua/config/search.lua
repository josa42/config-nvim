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
