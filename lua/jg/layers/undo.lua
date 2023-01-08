local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'mbbill/undotree',
  },

  map = {
    { 'n', '<leader>u', vim.cmd.UndotreeToggle },
  },
})
