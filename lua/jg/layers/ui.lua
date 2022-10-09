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
    'josa42/nvim-ui',
  },
})

layer.use({
  enabled = false,

  requires = {
    'stevearc/dressing.nvim',
    'MunifTanjim/nui.nvim',
  },

  setup = function()
    require('dressing').setup({
      input = {
        anchor = 'NW',
        border = 'rounded',
        default_prompt = '→',
        override = function(conf)
          conf.row = 1
          return conf
        end,
      },
      select = { enabled = false },
    })
  end,
})

layer.use({
  enabled = false,

  requires = { 'onsails/diaglist.nvim' },

  map = function()
    local diaglist = require('diaglist')
    return {
      -- { 'n', '<space>dw', diaglist.open_all_diagnostics },
      { 'n', '<space>l', diaglist.open_buffer_diagnostics },
    }
  end,

  setup = function()
    require('diaglist').init({
      -- optional settings
      -- below are defaults
      debug = false,

      -- increase for noisy servers
      debounce_ms = 150,
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
