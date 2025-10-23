if vim.fn.has('nvim-0.11') ~= 1 then
  vim.notify('Neovim 0.11+ is required for this configuration', vim.log.levels.ERROR)
  return
end

require('config.clipboard')
require('config.conceal')
require('config.misc')
require('config.diagnostics')
require('config.keymap')
require('config.quickfix')
require('config.spell')
require('config.lazy')
