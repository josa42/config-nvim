local layer = require('jg.lib.layer')

vim.g.indent_blankline_buftype_exclude = { 'nofile' }

layer.use({
  requires = {
    'lukas-reineke/indent-blankline.nvim',
  },

  setup = function()
    require('indent-o-matic').setup({
      max_lines = 10,
      standard_widths = { 2, 4, 8 },
    })
  end,
})
