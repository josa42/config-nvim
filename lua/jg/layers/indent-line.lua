local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'lukas-reineke/indent-blankline.nvim',
  },

  setup = function()
    vim.cmd(':hi! IndentBlanklineContextChar guifg=#4b5263')
    -- vim.cmd(':hi! link IndentBlanklineContextChar IndentBlanklineChar')
    require('indent_blankline').setup({
      -- for example, context is off by default, use this to turn it on
      show_current_context = true,
      show_current_context_start = false,

      -- use_treesitter = true,
      use_treesitter_scope = true,

      show_end_of_line = true,

      disable_with_nolist = true,

      filetype_exclude = {
        'tree',
        'lspinfo',
        'packer',
        'checkhealth',
        'help',
        'man',
        'lazy',
        '',
      },
    })
  end,

  -- autocmds = {
  --   {
  --     'FileType',
  --     pattern = { 'yaml' },
  --     callback = function()
  --       vim.cmd(':hi! IndentBlanklineContextChar guifg=#4b5263')
  --     end,
  --   },
  -- },
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
