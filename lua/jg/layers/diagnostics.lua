local layer = require('jg.lib.layer')
local signs = require('jg.signs')

layer.use({
  enabled = true,

  requires = {
    'folke/lsp-trouble.nvim',
  },

  map = {
    { 'n', __keymaps.goto_diagnostics_prev, '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
    { 'n', __keymaps.goto_diagnostics_next, '<cmd>lua vim.diagnostic.goto_next()<CR>' },
    { 'n', __keymaps.goto_diagnostics_list, ':TroubleToggle document_diagnostics<cr>' },
  },

  setup = function()
    vim.diagnostic.config({ underline = false, severity_sort = true })

    require('trouble').setup({
      mode = 'document_diagnostics',
      signs = signs.trouble,
      icons = false,
      auto_close = true,
    })

    vim.fn.sign_define('DiagnosticSignError', { text = signs.diagnostic.error, texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = signs.diagnostic.warning, texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = signs.diagnostic.info, texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = signs.diagnostic.hint, texthl = 'DiagnosticSignHint' })

    vim.cmd.hi({ 'link', 'DiagnosticVirtualTextOk', 'Comment', bang = true })
    vim.cmd.hi({ 'link', 'DiagnosticVirtualTextHint', 'Comment', bang = true })
    vim.cmd.hi({ 'link', 'DiagnosticVirtualTextInfo', 'Comment', bang = true })
    vim.cmd.hi({ 'link', 'DiagnosticVirtualTextWarn', 'Comment', bang = true })
    vim.cmd.hi({ 'link', 'DiagnosticVirtualTextError', 'Comment', bang = true })
  end,
})
