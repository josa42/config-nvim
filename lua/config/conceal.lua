vim.opt.conceallevel = 2
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc' },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})
