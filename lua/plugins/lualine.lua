return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'arkav/lualine-lsp-progress' },

    init = function()
      vim.cmd([[
        hi! StatusLineNC  guibg=#21252B
        hi! StatusLine    guibg=#21252B
        hi! StatusLuasnipIcon guifg=#a7d685 guibg=#21252B
        hi! StatusLuasnip     guifg=#7c818d guibg=#21252B
      ]])
    end,

    config = function()
      local signs = require('config.signs')
      local components = require('plugins.lualine.components')

      local color = {
        fg = '#7c818d',
        fg_strong = '#bcc3d2',
        bg = '#21252B',
        bg_command = '#f67680',
        bg_insert = '#a7d685',
        bg_visual = '#6ac0ff',
        bg_replace = '#e5a970',
        bg_terminal = '#f67680',
      }

      require('lualine').setup({
        options = {
          theme = {
            normal = {
              a = { bg = color.fg, fg = color.bg, gui = 'bold' },
              b = { bg = color.bg, fg = color.fg_strong },
              c = { bg = color.bg, fg = color.fg },
              x = { bg = color.bg, fg = color.fg },
              y = { bg = color.bg, fg = color.fg },
              z = { bg = color.bg, fg = color.fg },
            },
            command = {
              a = { bg = color.bg_command, fg = color.bg, gui = 'bold' },
            },
            insert = {
              a = { bg = color.bg_insert, fg = color.bg, gui = 'bold' },
            },
            visual = {
              a = { bg = color.bg_visual, fg = color.bg, gui = 'bold' },
            },
            replace = {
              a = { bg = color.bg_replace, fg = color.bg, gui = 'bold' },
            },
            terminal = {
              a = { bg = color.bg_terminal, fg = color.bg, gui = 'bold' },
            },
          },
          icons_enabled = false,
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = { 'tree', 'blame', 'fugitiveblame' },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            { 'filename', path = 1 },
          },
          lualine_c = {
            'fileformat',
            { 'branch', icons_enabled = true, icon = '' },
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              icons_enabled = true,
              sections = { 'error', 'warn' },
              symbols = signs.diagnostics,
            },
            components.luasnip_status(),
          },
          lualine_x = {
            components.lazy_status(),
          },
          lualine_y = { 'filesize' },
          lualine_z = { 'filetype' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {
            { 'filename', path = 1 },
          },
          lualine_c = {
            'fileformat',
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end,
  },
}
