local layer = require('jg.lib.layer')

layer.use({
  require = {
    'lukas-reineke/indent-blankline.nvim',
  },

  after = function()
    require('indent-o-matic').setup({
      max_lines = 10,
      standard_widths = { 2, 4, 8 },
    })
  end,
})
