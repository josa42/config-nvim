local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'lukas-reineke/indent-blankline.nvim',
  },

  init = function()
    vim.g.indent_blankline_buftype_exclude = { 'nofile' }
  end,
})
