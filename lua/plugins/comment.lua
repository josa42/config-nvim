return {
  {
    'folke/ts-comments.nvim',
    opts = {},

    events = { 'BufRead' },

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
}
