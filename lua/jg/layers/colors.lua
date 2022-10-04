-- colors
local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'NvChad/nvim-colorizer.lua',
  },
  setup = function()
    require('colorizer').setup({
      user_default_options = {
        mode = 'virtualtext',
      },
    })
  end,
})
