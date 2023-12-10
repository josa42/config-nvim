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
  },
}
