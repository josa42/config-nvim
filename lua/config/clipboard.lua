vim.opt.clipboard = { 'unnamedplus' }

local group = vim.api.nvim_create_augroup('config.clipboard', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWrite', 'InsertLeave' }, {
  group = group,
  callback = function()
    vim.opt.paste = false
  end,
})

vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = group,
  callback = function()
    vim.highlight.on_yank()
  end,
})
