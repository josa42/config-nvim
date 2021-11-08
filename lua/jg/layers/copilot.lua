local layer = require('jg.lib.layer')

layer.use {
  require = { 'github/copilot.vim' },
  before = function()
    -- Disable by default
    vim.g.copilot_filetypes = { ["*"] = false }
  end,
}


