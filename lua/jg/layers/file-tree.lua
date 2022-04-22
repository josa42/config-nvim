local layer = require('jg.lib.layer')

layer.use({
  enabled = true,

  requires = {
    'josa42/nvim-file-tree',
  },

  map = function()
    return {
      { 'n', '<leader>b', require('file-tree').toggle_smart },
      { 'n', '<leader>B', require('file-tree').close },
    }
  end,
})
