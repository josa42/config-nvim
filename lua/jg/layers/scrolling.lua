local layer = require('jg.lib.layer')

layer.use({
  enabled = true,
  requires = { 'karb94/neoscroll.nvim' },
  setup = function()
    require('neoscroll').setup({
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb' },
    })
  end,
})
