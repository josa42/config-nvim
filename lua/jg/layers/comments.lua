local layer = require('jg.lib.layer')

layer.use({
  requires = {
    { 'numToStr/Comment.nvim', dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    } },
  },

  map = {
    { 'n', '#', '<Plug>(comment_toggle_linewise_current)' },
    { 'v', '#', '<Plug>(comment_toggle_linewise_visual)' },
  },

  setup = function()
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
})
