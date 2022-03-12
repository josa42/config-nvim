local layer = require('jg.lib.layer')

layer.use({
  requires = {
    -- nvim-cmp and sources
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',

    'onsails/lspkind-nvim',
  },

  setup = function()
    vim.cmd('hi link CmpItemMenu Comment')

    local lspkind = require('lspkind')
    local cmp = require('cmp')
    cmp.setup({
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'vsnip' },
        { name = 'path' },
      }),
      snippet = {
        expand = function(args)
          vim.fn['vsnip#anonymous'](args.body)
        end,
      },
      formatting = {
        format = lspkind.cmp_format({
          with_text = false,
          menu = {
            buffer = '[buf]',
            nvim_lsp = '[lsp]',
            vsnip = '[snip]',
            nvim_lua = '[lua]',
            path = '[path]',
          },
        }),
      },
      mapping = {
        ['<C-Space>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.close()
          else
            cmp.complete()
          end
        end, {
          'i',
          'c',
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<TAB>'] = cmp.mapping.confirm({ select = true }),
      },
      experimental = {
        ghost_text = true,
      },
    })

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
})

-- copilot
layer.use({
  enabled = false,
  requires = { 'github/copilot.vim' },
  setup = function()
    -- Disable by default
    vim.g.copilot_filetypes = { ['*'] = false }
  end,
})
