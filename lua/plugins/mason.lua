return {
  {
    'williamboman/mason.nvim',

    cmd = { 'Mason', 'MasonUpdateAll' },

    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },

    opts = {},
  },
  {
    'RubixDev/mason-update-all',
    opts = {},
  },
}
