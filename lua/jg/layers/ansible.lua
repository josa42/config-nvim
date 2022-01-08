local layer = require('jg.lib.layer')

layer.use({
  init = function()
    vim.g.ansible_unindent_after_newline = 1
  end
})
