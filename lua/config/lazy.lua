local lazypath = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy/lazy.nvim')

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local lockfile_name = vim.fn.has('nvim-0.13') == 1 and 'lazy-lock.json' or 'lazy-lock--legacy.json'

require('lazy').setup({
  spec = 'plugins',
  lockfile = vim.fn.stdpath('config') .. '/' .. lockfile_name,
})
