vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.linebreak = true

local group = vim.api.nvim_create_augroup('config.indent', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWrite', 'InsertLeave' }, {
  group = group,
  callback = function()
    vim.opt.paste = false
  end,
})
