local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'chentoast/marks.nvim',
  },

  setup = function()
    require('marks').setup({})
  end,
})
