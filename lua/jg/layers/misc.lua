local plug = require('jg.lib.plug')
local command = require('jg.lib.command')

command.define('RG', { nargs = '+' }, "lua require('jg.lib.quickfix').rg(<f-args>)")
command.define('FD', { nargs = '+' }, "lua require('jg.lib.quickfix').fd(<f-args>)")

plug.require(
  -- Editing
  'Darazaki/indent-o-matic',
  'josa42/vim-templates',
  'tpope/vim-repeat',
  'phaazon/hop.nvim',
  -- Files
  'tpope/vim-eunuch'
)

plug.after(function()
  require('diffview').setup ({
    use_icons = false,
  })
  require('indent-o-matic').setup {
    standard_widths = { 2, 4, 8 },
  }
  require('hop').setup()
  vim.cmd("hi! link HopNextKey Special")
  vim.cmd("hi! link HopNextKey1 Special")
  vim.cmd("hi! link HopNextKey2 Special")

  vim.api.nvim_set_keymap('n', '<leader>f', ':HopWord<cr>', { noremap = true })
end)
