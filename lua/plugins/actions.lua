return {
  {
    'josa42/nvim-actions',
    -- dir = '~/github/josa42/nvim-actions',
    config = function()
      require('jg.actions').setup()
    end,

    events = { 'InsertEnter' },
  },
}
