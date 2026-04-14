return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    config = function()
      vim.api.nvim_set_hl(0, 'RenderMarkdownH1BgCustom', { bg = '#21252B', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH2BgCustom', { bg = '#21252B', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH3BgCustom', { bg = '#21252B', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH4BgCustom', { bg = '#21252B', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH5BgCustom', { bg = '#21252B', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH6BgCustom', { bg = '#21252B', force = true })

      require('render-markdown').setup({
        completions = { lsp = { enabled = true } },
        -- bold = { enabled = false },
        code = {
          enabled = true,
          style = 'full',
          border = 'thin',
          conceal_delimiters = true,
          language_icon = true,
          language_name = true,
          language_info = true,
          width = 'block',
          min_width = 120,
          right_pad = 1,
        },
        html = {
          comment = {
            conceal = false, -- Kommentare nicht ausblenden, immer sichtbar
          },
        },
        anti_conceal = {
          enabled = true,
          disabled_modes = { 'n' }, -- Anti-conceal im Normal-Modus deaktivieren
        },

        heading = {
          width = 'block',
          min_width = 120,
          right_pad = 1,
          icons = { ' ' },
          -- position = 'eol',
          -- position = 'right',
          position = 'overlay',
          signs = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' },
          backgrounds = {
            'RenderMarkdownH1BgCustom',
            'RenderMarkdownH2BgCustom',
            'RenderMarkdownH3BgCustom',
            'RenderMarkdownH4BgCustom',
            'RenderMarkdownH5BgCustom',
            'RenderMarkdownH6BgCustom',
          },
        },
        pipe_table = {
          min_width = 6,
        },
      })

      vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { link = 'DiffAdd', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { link = 'DiffAdd', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { link = 'DiffAdd', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { link = 'DiffAdd', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { link = 'DiffAdd', force = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { link = 'DiffAdd', force = true })

      vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#21252B', force = true })
      -- vim.api.nvim_set_hl(0, 'RenderMarkdownCodeBorder', { bg = '#2c323c', fg = '#5c6370', force = true })
    end,
  },

  {
    'selimacerbas/markdown-preview.nvim',
    dependencies = { 'selimacerbas/live-server.nvim' },
    opts = {},
  },

  {
    'timantipov/md-table-tidy.nvim',
    opts = {
      padding = 1, -- spaces around cell content
      key = '<leader>tt', -- triggers :TableTidy
    },

    config = function(_, opts)
      require('md-table-tidy').setup(opts)

      vim.keymap.set('n', '<leader>tj', function()
        local line = vim.api.nvim_get_current_line()
        local newline = line:gsub('[^|]', ' ')
        local curline = vim.api.nvim_win_get_cursor(0)[1]

        vim.api.nvim_buf_set_lines(0, curline, curline, false, { newline })

        local col = (newline:find(' ') or 1)
        vim.api.nvim_win_set_cursor(0, { curline + 1, col })
        vim.cmd.startinsert()
      end, { desc = 'Insert markdown table row below (keep only |)' })
    end,
  },
}
