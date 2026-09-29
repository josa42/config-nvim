return {
  {
    'josa42/nvim-quickfix',
    -- dir = '~/github/josa42/nvim-quickfix',

    event = { 'VeryLazy' },

    opts = {
      types = require('config.signs').diagnostic,
    },
  },
}
