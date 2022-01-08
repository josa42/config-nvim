local layer = require('jg.lib.layer')

layer.use({
  enabled = false,
  requires = { 'github/copilot.vim' },
  setup = function()
    -- Disable by default
    vim.g.copilot_filetypes = { ['*'] = false }
  end,
})
