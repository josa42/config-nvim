local layer = require('jg.lib.layer')

layer.use({
  requires = { 'stevearc/overseer.nvim' },

  setup = function()
    require('overseer').setup({})
  end,
})
