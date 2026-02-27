return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    config = function()
      require('render-markdown').setup({
        completions = { lsp = { enabled = true } },
        code = {
          conceal_delimiters = false,
          border = 'thin',
          language_left = '```',
        },
      })

      vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { link = 'DiffAdd' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { link = 'DiffAdd' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { link = 'DiffAdd' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { link = 'DiffAdd' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { link = 'DiffAdd' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { link = 'DiffAdd' })
    end,
  },

  {
    'selimacerbas/markdown-preview.nvim',
    dependencies = { 'selimacerbas/live-server.nvim' },
    opts = {},
  },
}
