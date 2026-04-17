return {
  'myakove/homeassistant-nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
  },
  enabled = vim.env.HOMEASSISTANT_TOKEN ~= nil,
  event = { 'BufRead', 'BufNewFile' }, -- Load on file open
  opts = {
    lsp = {
      enabled = true,
      cmd = { 'homeassistant-lsp', '--stdio' },
      settings = {
        homeassistant = {
          host = 'ws://homeassistant.local:8123/api/websocket',
          token = vim.env.HOMEASSISTANT_TOKEN,
        },
        cache = {
          enabled = true,
          ttl = 300, -- 5 minutes
        },
        diagnostics = {
          enabled = true,
          debounce = 500,
        },
      },
    },
  },
}
