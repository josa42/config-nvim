local signs = require('config.signs')
return {
  {
    'folke/trouble.nvim',
    opts = {
      mode = 'document_diagnostics',
      signs = signs.trouble,
      icons = false,
      auto_close = true,
    },
    keys = {
      { '<leader>d', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Toggle diagnostics' },
      { '<leader>bd', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Toggle buffer diagnostics' },
    },
  },
}
