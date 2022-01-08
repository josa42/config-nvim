-- colors
local layer = require('jg.lib.layer')

layer.use({
  requires = {
    { 'rrethy/vim-hexokinase', { ['do'] = 'GO111MODULE=off make hexokinase' } },
    '~/github/josa42/axiom-colors',
  },

  init = function()
    vim.g.Hexokinase_highlighters = { 'virtual' }
    vim.g.Hexokinase_ftAutoload = { '*' }
    vim.g.Hexokinase_refreshEvents = { 'BufWritePost', 'CursorHold' }
  end,
})
