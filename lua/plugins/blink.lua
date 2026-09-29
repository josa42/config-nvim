local signs = require('config.signs')

-- Per-source glyphs shown in the menu's right-hand column. LSP items are keyed
-- by client name so each server gets its own mark, matching the old nvim-cmp
-- `nvim_lsp:<client>` labels.
local source_icons = {
  ['snippets'] = '',
  ['lsp'] = 'lsp',
  ['lsp:bashls'] = '',
  ['lsp:cssls'] = '',
  ['lsp:docker_language_server'] = '',
  ['lsp:dockerls'] = '',
  ['lsp:gh_actions_ls'] = '',
  ['lsp:gopls'] = '',
  ['lsp:html'] = '',
  ['lsp:jsonls'] = '',
  ['lsp:lua_ls'] = '󰢱',
  ['lsp:vimls'] = '',
  ['lsp:vtsls'] = '',
  ['lazydev'] = '',
  ['path'] = '',
}

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

local function source_label(ctx)
  local id = ctx.item.source_id
  if id == 'lsp' then
    local client = ctx.item.client_id and vim.lsp.get_client_by_id(ctx.item.client_id)
    if client then
      return source_icons['lsp:' .. client.name] or source_icons.lsp
    end
  end
  return source_icons[id] or id
end

local function luasnip()
  local ok, ls = pcall(require, 'luasnip')
  return ok and ls or nil
end

local function copilot()
  local ok, c = pcall(require, 'copilot.suggestion')
  return ok and c or nil
end

return {
  {
    'saghen/blink.cmp',

    lazy = false,
    version = '*',

    dependencies = {
      'L3MON4D3/LuaSnip',
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
    },

    opts = {
      snippets = { preset = 'luasnip' },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
        providers = {
          lazydev = {
            name = 'lazydev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },

      appearance = {
        kind_icons = kind_icons,
        nerd_font_variant = 'mono',
        -- The colorscheme styles nvim-cmp's highlight groups; this links the
        -- BlinkCmp* groups onto their CmpItem* equivalents.
        use_nvim_cmp_as_default = true,
      },

      completion = {
        list = {
          -- Match nvim-cmp's PreselectMode.None: never preselect an entry.
          selection = { preselect = false, auto_insert = false },
        },
        menu = {
          draw = {
            -- No left inset, so the popup's edge and the label both start on
            -- the typed word, the way nvim-cmp rendered it. blink folds
            -- padding[1] into its align_to calculation.
            padding = { 0, 1 },
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon' },
              { 'source' },
            },
            components = {
              source = {
                text = source_label,
                highlight = 'BlinkCmpSource',
              },
            },
          },
        },
        documentation = {
          auto_show = true,
        },
      },

      signature = { enabled = true },

      keymap = {
        preset = 'none',

        -- Toggle the menu.
        ['<C-Space>'] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.hide()
            end
            return cmp.show()
          end,
        },

        -- Accept only an explicitly selected entry.
        ['<CR>'] = { 'accept', 'fallback' },
        -- Accept the first entry even when nothing is selected.
        ['<Tab>'] = { 'select_and_accept', 'fallback' },

        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },

        -- copilot suggestion, else expand a snippet
        ['<C-e>'] = {
          function()
            local c = copilot()
            if c and c.is_visible() then
              c.accept()
              return true
            end
            local ls = luasnip()
            if ls and ls.expandable() then
              ls.expand()
              return true
            end
          end,
          'fallback',
        },

        -- snippet jump forward, else cycle copilot suggestions
        ['<C-n>'] = {
          function(cmp)
            local ls = luasnip()
            if ls and ls.locally_jumpable(1) then
              ls.jump(1)
              return true
            end
            local c = copilot()
            if c and c.is_visible() then
              cmp.hide()
              c.next()
              return true
            end
          end,
          'fallback',
        },

        ['<C-p>'] = {
          function(cmp)
            local ls = luasnip()
            if ls and ls.locally_jumpable(-1) then
              ls.jump(-1)
              return true
            end
            local c = copilot()
            if c and c.is_visible() then
              cmp.hide()
              c.prev()
              return true
            end
          end,
          'fallback',
        },

        -- cycle a snippet's choice node
        ['-'] = {
          function()
            local ls = luasnip()
            if ls and ls.choice_active() then
              ls.change_choice(1)
              return true
            end
          end,
          'fallback',
        },
      },
    },

    config = function(_, opts)
      -- lazydev only contributes inside a Neovim config or plugin, so add it
      -- to the lua sources rather than the global default list.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('plugins.blink.lazydev', { clear = true }),
        pattern = 'lua',
        callback = function()
          vim.b.blink_cmp_sources = { 'lazydev', 'lsp', 'path', 'snippets' }
        end,
      })

      require('blink.cmp').setup(opts)
    end,
  },
}
