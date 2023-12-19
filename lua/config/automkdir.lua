-- create missing nested directories for new files
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('config.automkdir', { clear = true }),
  callback = function(args)
    local dir = vim.fs.dirname(args.match)
    if dir ~= nil and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})
