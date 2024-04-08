return {
  enabled = false,
  'josa42/nvim-rompt',
  dir = '~/github/josa42/nvim-prompt',

  event = 'VeryLazy',

  keys = function()
    return {
      {
        '<leader>.',
        require('prompt.builtins.any').open,
      },
    }
  end,
}
