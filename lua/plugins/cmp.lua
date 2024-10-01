return {
  {
    lazy = false,

    'hrsh7th/nvim-cmp',

    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },

    keys = {
      { '<c-space>', function() end, mode = 'n' },
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

      local sources = {
        ['luasnip'] = '',
        ['nvim_lsp'] = 'lsp',
        ['nvim_lsp:bashls'] = '',
        ['nvim_lsp:cssls'] = '',
        ['nvim_lsp:dockerls'] = '',
        ['nvim_lsp:gopls'] = '',
        ['nvim_lsp:html'] = '',
        ['nvim_lsp:jsonls'] = '',
        ['nvim_lsp:lua_ls'] = '󰢱',
        ['nvim_lsp:typescript-tools'] = '',
        ['nvim_lsp:vimls'] = '',
        ['nvim_lua'] = '',
        ['path'] = '',
      }

      local function formatSource(entry)
        local name = entry.source.name

        if name == 'nvim_lsp' then
          local lsp_name = ((entry.source.source or {}).client or {}).name
          if lsp_name then
            name = lsp_name and string.format('%s:%s', name, lsp_name) or lsp_name
          end
        end

        return sources[name] or name
      end

      -- vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })

      local cmp = require('cmp')
      local has_luasnip, luasnip = pcall(require, 'luasnip')
      local has_copilot, copilot = pcall(require, 'copilot.suggestion')

      cmp.setup({
        preselect = cmp.PreselectMode.None,

        sources = cmp.config.sources({
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
          fields = { 'abbr', 'kind', 'menu' },
          format = function(entry, item)
            local source = formatSource(entry)

            return vim.tbl_extend('force', item, {
              kind = kind_icons[item.kind] or item.kind,
              menu = item.menu ~= nil and string.format('%s %s', source, item.menu) or source,
            })
          end,
        },

        mapping = {
          ['<C-Space>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.close()
            else
              cmp.complete()
            end
          end, { 'i', 'c' }),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping(function(fallback)
            if has_copilot and copilot.is_visible() then
              copilot.accept()
            elseif has_luasnip and luasnip.expandable() then
              luasnip.expand()
            else
              fallback()
            end
          end),
          ['<C-n>'] = cmp.mapping(function(fallback)
            if has_luasnip and luasnip.jumpable(1) then
              luasnip.jump(1)
            elseif has_copilot and copilot.is_visible() then
              cmp.close()
              copilot.next()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-p'] = cmp.mapping(function(fallback)
            if has_luasnip and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif has_copilot and copilot.is_visible() then
              cmp.close()
              copilot.prev()
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
