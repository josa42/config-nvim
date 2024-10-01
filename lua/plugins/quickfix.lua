return {
  {
    'josa42/nvim-quickfix',
    -- dir = '~/github/josa42/nvim-quickfix',

    events = { 'VeryLazy' },

    opts = {
      types = require('config.signs').diagnostic,
    },
  },
}
