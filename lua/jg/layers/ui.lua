local layer = require('jg.lib.layer')

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
      stages = 'fade',
      icons = {
        ERROR = _G.__icons.diagnostic.error,
        WARN = _G.__icons.diagnostic.warning,
        INFO = _G.__icons.diagnostic.info,
        DEBUG = '', -- _G.__icons.diagnostic.hint
        TRACE = '✎',
      },
    })

    vim.notify = notify
  end,
})

layer.use({
  setup = function()
    vim.ui.input = require('jg.lib.input')
  end,
})
