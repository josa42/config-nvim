local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'lukas-reineke/indent-blankline.nvim',
  },
})

layer.use({
  requires = {
    'lukas-reineke/virt-column.nvim',
  },

  setup = function()
    vim.opt.colorcolumn = { 81, 121 }

    require('virt-column').setup({ char = '│' })
  end,
})
