local layer = require('jg.lib.layer')

layer.use({
  requires = { 'karb94/neoscroll.nvim' },
  setup = function()
    require('neoscroll').setup({
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb' },
    })
  end,
})
