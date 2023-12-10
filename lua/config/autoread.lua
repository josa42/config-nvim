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

-- create missing nested directories for new files
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if type(dir) == 'string' then
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
      end
    end
  end,
})
