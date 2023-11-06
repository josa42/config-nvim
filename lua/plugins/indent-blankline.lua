return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPre' },
    opts = {
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
    },
  },

  -- init = function()
  --   vim.cmd(':hi! IndentBlanklineContextChar guifg=#4b5263')
  -- end,
}
