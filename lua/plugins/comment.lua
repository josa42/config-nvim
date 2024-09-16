local enableNativeComments = false and vim.fn.has('nvim-0.10.0') == 1

return {
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
    enabled = enableNativeComments,

    init = function(opts)
      local group = vim.api.nvim_create_augroup('plugins.comment.ft', { clear = true })

      local fts = {
        monkeyc = '// %s',
        json = '// %s',
        jsonc = '// %s',
        gomod = '// %s',
      }

      for ft, value in pairs(fts) do
        vim.api.nvim_create_autocmd('FileType', {
          group = group,
          pattern = ft,
          callback = function()
            vim.bo.commentstring = value
          end,
        })
      end
    end,
  },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },

    event = 'VeryLazy',
    enabled = not enableNativeComments,

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
