local layer = require('jg.lib.layer')

layer.use({
  enabled = false,

  requires = {
    { 'josa42/nvim-file-tree' },
    -- { 'josa42/nvim-file-tree', dir = '~/github/josa42/nvim-file-tree' },
  },

  map = function()
    return {
      { 'n', '<leader>sb', require('file-tree').toggle_smart },
      { 'n', '<leader>sB', require('file-tree').close },
    }
  end,
})
