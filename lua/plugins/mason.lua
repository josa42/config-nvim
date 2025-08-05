return {
  {
    'williamboman/mason.nvim',

    cmd = { 'Mason', 'MasonUpdateAll' },

    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      {
        'RubixDev/mason-update-all',
        opts = {},
      },
    },
    opts = {},
  },
}
