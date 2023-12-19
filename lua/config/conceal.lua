vim.opt.conceallevel = 2

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config.conceal', { clear = true }),
  pattern = { 'json', 'jsonc' },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})
