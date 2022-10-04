local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'numToStr/Comment.nvim',
  },

  map = {
    { 'n', '#', '<Plug>(comment_toggle_linewise_current)' },
  },

  setup = function()
    require('Comment').setup()

    local ft = require('Comment.ft')
    ft.monkeyc = { '//%s', '/*%s*/' }
    ft.json = { '//%s', '/*%s*/' }
    ft.jsonc = { '//%s', '/*%s*/' }
  end,
})
