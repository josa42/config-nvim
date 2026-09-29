vim.opt.autoread = true

local group = vim.api.nvim_create_augroup('config.autoread', { clear = true })

-- reload buffers whose file changed on disk
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = group,
  command = 'silent! checktime',
})

-- save on focus lost!
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = group,
  command = 'silent! update',
})
