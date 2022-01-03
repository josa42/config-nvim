local layer = require('jg.lib.layer')
local plug = require('jg.lib.plug')
local command = require('jg.lib.command')

command.define('RG', { nargs = '+' }, "lua require('jg.lib.quickfix').rg(<f-args>)")
command.define('FD', { nargs = '+' }, "lua require('jg.lib.quickfix').fd(<f-args>)")

plug.require(
  -- fix performance of CursorHold and CursorHoldI events

  'antoinemadec/FixCursorHold.nvim',

  -- Editing
  'Darazaki/indent-o-matic',
  'josa42/vim-templates',
  'tpope/vim-repeat',

  -- Files
  'tpope/vim-eunuch',
  'jghauser/mkdir.nvim'
)

plug.after(function()
  require('diffview').setup({
    use_icons = false,
  })
  require('indent-o-matic').setup({
    standard_widths = { 2, 4, 8 },
  })
end)

layer.use({
  require = {
    'sudormrfbin/cheatsheet.nvim',
  },

  after = function()
    require('cheatsheet').setup({
      bundled_cheatsheets = {
        disabled = { 'lua', 'markdown', 'nerd-fonts', 'netrw', 'regex', 'unicode' },
      },
    })
  end,
})
