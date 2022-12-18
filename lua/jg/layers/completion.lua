local layer = require('jg.lib.layer')

layer.use({
  requires = {
    -- nvim-cmp and sources
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    -- fallback
    'hrsh7th/cmp-buffer',
    -- git
    'davidsierradz/cmp-conventionalcommits',
    -- snippets
    'saadparwaiz1/cmp_luasnip',
  },

  setup = function()
    -- See:
    -- - https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
    -- - https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt

    local kind_icons = {
      Text = '',
      Method = '',
      Function = '',
      Constructor = '',
      Field = '',
      Variable = '',
      Class = '',
      Interface = '',
      Module = '',
      Property = '',
      Unit = '',
      Value = '',
      Enum = '',
      Keyword = '',
      Snippet = '',
      Color = '',
      File = '',
      Reference = '',
      Folder = '',
      EnumMember = '',
      Constant = '',
      Struct = '',
      Event = '',
      Operator = '',
      TypeParameter = '',
    }

    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local function if_visible(fn, fallback_fn)
      return function(fallback)
        fallback = fallback_fn or fallback
        if cmp.visible() then
          fn()
        else
          fallback()
        end
      end
    end

    local mapping_cmp_toggle = cmp.mapping(if_visible(cmp.close, cmp.complete), { 'i', 'c' })

    cmp.setup({
      window = {
        completion = {
          -- col_offset = -3,
          -- side_padding = 0,
        },
      },

      sources = cmp.config.sources({
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'path' },
      }, {
        { name = 'buffer' },
      }),

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      formatting = {
        fields = { 'abbr', 'kind' },
        format = function(entry, item)
          return vim.tbl_extend('force', item, {
            kind = kind_icons[item.kind] or item.kind,
          })
        end,
      },

      mapping = {
        ['<C-e>'] = mapping_cmp_toggle,
        ['<C-Space>'] = mapping_cmp_toggle,
        -- ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        -- ['<TAB>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable() then
            luasnip.jump(1)
          elseif cmp.visible() then
            cmp.confirm({ select = true })
          elseif luasnip.expandable() then
            luasnip.expand()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['-'] = function(fallback)
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end,
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
      },

      experimental = {
        ghost_text = true,
      },
    })

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'conventionalcommits' },
      }),
    })

    local ok, autopairs_cmp = pcall(require, 'nvim-autopairs.completion.cmp')

    if ok then
      cmp.event:on('confirm_done', autopairs_cmp.on_confirm_done())
    end
  end,
})
