local layer = require('jg.lib.layer')

layer.use({
  autocmds = {
    {
      'TermOpen',
      callback = function()
        vim.opt_local.colorcolumn = {}
      end,
    },
  },
})
