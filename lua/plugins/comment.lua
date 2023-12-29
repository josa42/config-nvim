return {
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },

    event = 'VeryLazy',

    keys = {
      { '#', '<Plug>(comment_toggle_linewise_current)' },
      { '#', '<Plug>(comment_toggle_linewise_visual)', mode = { 'v' } },
    },

    config = function()
      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })

      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })

      local ft = require('Comment.ft')
      ft.monkeyc = { '//%s', '/*%s*/' }
      ft.json = { '//%s', '/*%s*/' }
      ft.jsonc = { '//%s', '/*%s*/' }
      ft.gomod = { '//%s' }
    end,
  },
}
