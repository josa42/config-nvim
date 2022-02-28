local layer = require('jg.lib.layer')

-- quickfix list
layer.use({
  requires = { 'kevinhwang91/nvim-bqf' },

  setup = function()
    vim.o.qftf = '{info -> v:lua.require("jg.lib.quickfix").format(info)}'
  end,
})

layer.use({
  enabled = true,

  requires = {
    'stevearc/dressing.nvim',
    'MunifTanjim/nui.nvim',
  },

  setup = function()
    require('dressing').setup({
      input = {
        anchor = 'NW',
        row = 1,
        border = 'rounded',
        default_prompt = '→',
      },
      select = { enabled = false },
    })
  end,
})
