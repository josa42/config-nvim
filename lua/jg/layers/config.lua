local layer = require('jg.lib.layer')

layer.use({
  enabled = not vim.fn.has('nvim-0.9'),
  requires = {
    'editorconfig/editorconfig-vim',
  },
})
