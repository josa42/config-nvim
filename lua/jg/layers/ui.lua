local layer = require('jg.lib.layer')
local signs = require('jg.signs')

-- quickfix list
layer.use({
  requires = {
    'kevinhwang91/nvim-bqf',
    'josa42/nvim-quickfix',
  },

  commands = {
    RG = { "lua require('jg.quickfix.tools').rg(<f-args>)", nargs = '+' },
    FD = { "lua require('jg.quickfix.tools').fd(<f-args>)", nargs = '+' },
  },

  setup = function()
    require('bqf').setup({
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        should_preview_cb = function(bufnr)
          return not vim.api.nvim_buf_get_name(bufnr):match('^fugitive://')
        end,
      },
    })
  end,
})

layer.use({
  requires = {
    'rcarriga/nvim-notify',
  },
  setup = function()
    local notify = require('notify')

    notify.setup({
      render = 'minimal',
      stages = 'static',
      icons = signs.notify,
    })

    vim.notify = notify
  end,
})

layer.use({
  requires = {
    { 'josa42/nvim-ui' },
    -- { 'josa42/nvim-ui', dir = '~/github/josa42/nvim-ui' },
  },
  setup = function()
    -- use nvim-telescope/telescope-ui-select.nvim for select
    require('jg.ui').setup({ select = false })
  end,
})

