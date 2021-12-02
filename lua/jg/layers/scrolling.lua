local layer = require('jg.lib.layer')

layer.use({
  enabled = false,
  require = { 'psliwka/vim-smoothie' },
})

layer.use({
  require = { 'karb94/neoscroll.nvim' },
  after = function()
    require('neoscroll').setup()
  end,
})
