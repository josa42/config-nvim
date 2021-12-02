local layer = require('jg.lib.layer')

layer.use({
  require = { 'mfussenegger/nvim-dap', 'Pocco81/DAPInstall.nvim' },

  after = function()
    local dap_install = require('dap-install')
    dap_install.config('chrome', {})
  end,
})
