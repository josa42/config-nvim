-- colors
local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'NvChad/nvim-colorizer.lua',
  },
  setup = {
    {
      'colorizer',
      user_default_options = {
        mode = 'virtualtext',
      },
    },
  },
})
