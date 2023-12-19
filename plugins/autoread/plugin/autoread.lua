vim.opt.autoread = true

local group = vim.api.nvim_create_augroup('config.autoread', { clear = true })

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = group,
  command = 'silent! !',
})

-- save on focus lost!
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = group,
  command = 'silent! update',
})

-- ignore removed files
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = group,
  command = 'execute',
})
