local layer = require('jg.lib.layer')

layer.use({
  require = {
    'folke/lsp-trouble.nvim',
  },

  map = {
    { 'n', __keymaps.goto_diagnostics_prev, '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
    { 'n', __keymaps.goto_diagnostics_prev, '<cmd>lua vim.diagnostic.goto_next()<CR>' },
    { 'n', __keymaps.goto_diagnostics_list, ':TroubleToggle document_diagnostics<cr>' },
  },

  after = function()
    require('trouble').setup({
      mode = 'document_diagnostics',
      signs = {
        error = _G.__icons.diagnostic.error,
        warning = _G.__icons.diagnostic.warning,
        hint = _G.__icons.diagnostic.hint,
        information = _G.__icons.diagnostic.info,
      },
      icons = false,
      auto_close = true,
    })

    vim.fn.sign_define('DiagnosticSignError', { text = _G.__icons.diagnostic.error, texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = _G.__icons.diagnostic.warning, texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = _G.__icons.diagnostic.info, texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = _G.__icons.diagnostic.hint, texthl = 'DiagnosticSignHint' })
  end,
})
