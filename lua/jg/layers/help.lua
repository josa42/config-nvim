local layer = require('jg.lib.layer')

layer.use({
  require = {
    'folke/which-key.nvim',
  },

  after = function()
    require('which-key').setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    })
  end,
})
