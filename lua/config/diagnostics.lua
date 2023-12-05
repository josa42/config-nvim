local signs = require('config.signs')
vim.diagnostic.config({ underline = false, severity_sort = true })

vim.fn.sign_define('DiagnosticSignError', { text = signs.diagnostic.error, texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = signs.diagnostic.warning, texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = signs.diagnostic.info, texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = signs.diagnostic.hint, texthl = 'DiagnosticSignHint' })

vim.cmd.hi({ 'link', 'DiagnosticVirtualTextOk', 'Comment', bang = true })
vim.cmd.hi({ 'link', 'DiagnosticVirtualTextHint', 'Comment', bang = true })
vim.cmd.hi({ 'link', 'DiagnosticVirtualTextInfo', 'Comment', bang = true })
vim.cmd.hi({ 'link', 'DiagnosticVirtualTextWarn', 'Comment', bang = true })
vim.cmd.hi({ 'link', 'DiagnosticVirtualTextError', 'Comment', bang = true })