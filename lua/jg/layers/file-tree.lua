local layer = require('jg.lib.layer')

layer.use {
  require = { { 'josa42/nvim-filetree', { tag = '*' } } },

  map = {
    { 'n', '<leader>b', ':call TreeToggleSmart()<CR>' },
    { 'n', '<leader>B', ':call TreeClose()<CR>'         },
  },
}
