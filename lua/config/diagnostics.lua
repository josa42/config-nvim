local signs = require('config.signs')

vim.diagnostic.config({
  underline = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.diagnostic.error,
      [vim.diagnostic.severity.WARN] = signs.diagnostic.warning,
      [vim.diagnostic.severity.INFO] = signs.diagnostic.info,
      [vim.diagnostic.severity.HINT] = signs.diagnostic.hint,
    },
  },
})

vim.cmd.hi({ 'link', 'DiagnosticVirtualTextOk', 'Comment', bang = true })
vim.cmd.hi({ 'link', 'DiagnosticVirtualTextHint', 'Comment', bang = true })
vim.cmd.hi({ 'link', 'DiagnosticVirtualTextInfo', 'Comment', bang = true })
vim.cmd.hi({ 'link', 'DiagnosticVirtualTextWarn', 'Comment', bang = true })
vim.cmd.hi({ 'link', 'DiagnosticVirtualTextError', 'Comment', bang = true })

vim.diagnostic.config({
  float = { border = 'single' },
})

vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.keymap.set('n', '<leader>jd', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '<leader>kd', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
