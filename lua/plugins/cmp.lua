return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },

    map = {
      { 'n', '<c-space>', function() end },
    },

    config = function()
      -- See:
      -- - https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
      -- - https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt

      local kind_icons = {
        Copilot = '',
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
        Snippet = '',
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
      -- vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })

      local cmp = require('cmp')
      local has_luasnip, luasnip = pcall(require, 'luasnip')

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
        preselect = cmp.PreselectMode.None,

        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'luasnip' },
          { name = 'nvim_lua' },
          { name = 'nvim_lsp' },
          { name = 'path' },
        }),

        snippet = {
          expand = function(args)
            if has_luasnip then
              luasnip.lsp_expand(args.body)
            end
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
          ['<C-Space>'] = mapping_cmp_toggle,
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-e>'] = cmp.mapping(function(fallback)
            if has_luasnip and luasnip.expandable() then
              luasnip.expand()
            else
              fallback()
            end
          end),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if has_luasnip and luasnip.jumpable(1) then
              luasnip.jump(1)
            elseif cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if has_luasnip and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['-'] = function(fallback)
            if has_luasnip and luasnip.choice_active() then
              luasnip.change_choice(1)
            else
              fallback()
            end
          end,
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
        },
      })

      local ok, autopairs_cmp = pcall(require, 'nvim-autopairs.completion.cmp')
      if ok then
        cmp.event:on('confirm_done', autopairs_cmp.on_confirm_done())
      end
    end,
  },
}
