local layer = require('jg.lib.layer')

layer.use({
  enabled = true,

  requires = {
    'josa42/nvim-file-tree',
  },

  map = {
    { 'n', '<leader>b', ':lua require("file-tree").toggle_smart()<CR>' },
    { 'n', '<leader>B', ':lua require("file-tree").close()<CR>' },
  },
})
