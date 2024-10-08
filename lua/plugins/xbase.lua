return {
  {
    'xbase-lab/xbase',
    enabled = false,
    build = 'make install', -- or "make install && make free_space" (not recommended, longer build time)
    dependnecies = {
      'neovim/nvim-lspconfig',
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "nvim-lua/plenary.nvim", -- optional/requirement of telescope.nvim
      -- "stevearc/dressing.nvim", -- optional (in case you don't use telescope but something else)
    },
    opts = {},
  },
}
