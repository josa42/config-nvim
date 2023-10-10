local layer = require('jg.lib.layer')

layer.use({
  requires = {
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl' },
  },

  setup = function()
    vim.cmd(':hi! IndentBlanklineContextChar guifg=#4b5263')
    require('ibl').setup({
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },

      exclude = {
        filetypes = {
          'tree',
          'lspinfo',
          'packer',
          'checkhealth',
          'help',
          'man',
          'lazy',
          '',
        },
      },
    })
  end,
})

layer.use({
  requires = {
    'lukas-reineke/virt-column.nvim',
  },

  setup = function()
    vim.opt.colorcolumn = { 81, 121 }

    require('virt-column').setup({ char = '│' })
  end,

  autocmds = {
    {
      'filetype',
      pattern = { 'help' },
      callback = function()
        vim.opt.colorcolumn = vim.opt_local.modifiable:get() and { 79 } or {}
      end,
    },
    {
      'filetype',
      pattern = { 'lazy' },
      callback = function()
        vim.opt.colorcolumn = {}
      end,
    },
  },
})
