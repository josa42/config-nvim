local layer = require('jg.lib.layer')

-- quickfix list
layer.use({
  requires = {
    'kevinhwang91/nvim-bqf',
    'josa42/nvim-quickfix',
  },
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
