local layer = require('jg.lib.layer')

--------------------------------------------------------------------------------

layer.use({
  requires = {
    -- Files
    'tpope/vim-eunuch',
  },
})

--------------------------------------------------------------------------------
-- automatically create nested directories for new files

layer.use({
  setup = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, 'p')
        end
      end,
    })
  end,
})

--------------------------------------------------------------------------------
-- replace gx mapping
layer.use({
  requires = {
    -- { 'josa42/nvim-gx', dir = '~/github/josa42/nvim-gx' },
    { 'josa42/nvim-gx', branch = 'dev' },
  },
})
