return {
  {
    'mason-org/mason.nvim',

    cmd = { 'Mason', 'MasonUpdateAll' },

    dependencies = {
      'mason-org/mason-lspconfig.nvim',
      {
        'RubixDev/mason-update-all',
        opts = {},
        -- Command: nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'
      },
    },
    opts = {
      registries = {
        'lua:local-mason-registry', -- your local registry
        'github:mason-org/mason-registry', -- keep the default
      },
    },
  },
}
