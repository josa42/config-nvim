local layer = require('jg.lib.layer')
local lsp = require('jg.lib.lsp')
local au = require('jg.lib.autocmd')
local hi = require('jg.lib.highlight')

local l = {}

layer.use({
  require = {
    -- nvim-cmp and sources
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',

    'onsails/lspkind-nvim',
  },

  after = function()

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
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      snippet = {
        expand = function(args)
          vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
        end,
      },
      formatting = {
        format = lspkind.cmp_format({
          with_text = true,
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
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      experimental = {
        ghost_text = true,
      },
    })
  end,
})
