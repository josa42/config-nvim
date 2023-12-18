return {
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      local signs = require('config.signs')

      notify.setup({
        render = 'wrapped-compact',
        stages = 'static',
        icons = signs.notify,
      })

      vim.notify = notify
    end,
  },
}
