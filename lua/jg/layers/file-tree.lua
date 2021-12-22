local layer = require('jg.lib.layer')

layer.use({
  enabled = false,

  require = {
    { 'josa42/nvim-filetree', { tag = '*' } },
  },

  map = {
    { 'n', '<leader>b', ':call TreeToggleSmart()<CR>' },
    { 'n', '<leader>B', ':call TreeClose()<CR>' },
  },
})

layer.use({
  enabled = true,

  require = {
    'josa42/nvim-file-tree',
  },

  map = {
    { 'n', '<leader>b', ':lua require("jg.file-tree").toggleSmart()<CR>' },
    { 'n', '<leader>B', ':lua require("jg.file-tree").close()<CR>' },
  },
})
