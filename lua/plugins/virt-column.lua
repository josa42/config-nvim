return {
  {
    'lukas-reineke/virt-column.nvim',
    opts = { char = '│' },
    init = function()
      vim.opt.colorcolumn = '81,121'
    end,
  },
}
