-- colors
local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'NvChad/nvim-colorizer.lua',
  },
  setup = function()
    require('colorizer').setup({
      filetypes = {
        -- Highlight all files:
        '*',
        -- Exclude from highlighting:
        '!vim-plug',
        '!mason',
      },
      user_default_options = {
        mode = 'virtualtext',
      },
    })
  end,
})
