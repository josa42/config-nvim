local layer = require('jg.lib.layer')

layer.use({
  requires = {
    -- nvim-cmp and sources
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
  },

  setup = function()
    -- See:
    -- - https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
    -- - https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt

    local kind_icons = {
      Text = '',
      Method = '',
      Function = '',
      Constructor = '',
      Field = '',
      Variable = '',
      Class = 'ﴯ',
      Interface = '',
      Module = '',
      Property = 'ﰠ',
      Unit = '',
      Value = '',
      Enum = '',
      Keyword = '',
      Snippet = '',
      Color = '',
      File = '',
      Reference = '',
      Folder = '',
      EnumMember = '',
      Constant = '',
      Struct = '',
      Event = '',
      Operator = '',
      TypeParameter = '',
    }

    -- TODO enable codicons, once nerdfont 2.2.0 is released
    -- local kind_icons = {
    --   Text = '  ',
    --   Method = '  ',
    --   Function = '  ',
    --   Constructor = '  ',
    --   Field = '  ',
    --   Variable = '  ',
    --   Class = '  ',
    --   Interface = '  ',
    --   Module = '  ',
    --   Property = '  ',
    --   Unit = '  ',
    --   Value = '  ',
    --   Enum = '  ',
    --   Keyword = '  ',
    --   Snippet = '  ',
    --   Color = '  ',
    --   File = '  ',
    --   Reference = '  ',
    --   Folder = '  ',
    --   EnumMember = '  ',
    --   Constant = '  ',
    --   Struct = '  ',
    --   Event = '  ',
    --   Operator = '  ',
    --   TypeParameter = '  ',
    -- }

    local source_labels = {
      buffer = '[buf]',
      nvim_lsp = '[lsp]',
      vsnip = '[snip]',
      nvim_lua = '[lua]',
      path = '[path]',
    }

    local cmp = require('cmp')

    local cmp_toggle = function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end

    local visible_map = function(fn)
      return cmp.mapping(function(fallback)
        if cmp.visible() then
          fn()
        else
          fallback()
        end
      end, { 'i', 's' })
    end

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
        format = function(entry, item)
          return vim.tbl_extend('force', item, {
            kind = kind_icons[item.kind] or item.kind,
            menu = source_labels[entry.source.name] or ('[' .. entry.source.name .. ']'),
          })
        end,
      },
      mapping = {
        ['<C-Space>'] = cmp.mapping(cmp_toggle, { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<TAB>'] = cmp.mapping.confirm({ select = true }),
        ['<Down>'] = visible_map(cmp.select_next_item),
        ['<Up>'] = visible_map(cmp.select_prev_item),
        ['<C-n>'] = visible_map(cmp.select_next_item),
        ['<C-p>'] = visible_map(cmp.select_prev_item),
      },
      experimental = {
        ghost_text = true,
      },
    })

    cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
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
