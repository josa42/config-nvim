-- colors
local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'NvChad/nvim-colorizer.lua',
  },
  setup = function()
    require('colorizer').setup({
      filetypes = {
        '*', -- Highlight all files, but customize some others.
        '!vim-plug', -- Exclude vim from highlighting.
      },
      user_default_options = {
        mode = 'virtualtext',
      },
    })
  end,
})
