local signs = require('config.signs')

local virtual_lines = {
  format = function(d)
    if d.code then
      return d.source .. '(' .. d.code .. '): ' .. d.message
    end
    return d.source .. ': ' .. d.message
  end,
}

vim.diagnostic.config({
  underline = false,
  severity_sort = true,
  virtual_lines = false,
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
  update_in_insert = true,
  virtual_text = false,
  float = { border = 'single' },
})

-- Disable the plugin in Lazy.nvim
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lazy',
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

vim.keymap.set('n', 'gK', function()
  vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines and virtual_lines or false })
end, { desc = 'Toggle diagnostic virtual_lines' })
