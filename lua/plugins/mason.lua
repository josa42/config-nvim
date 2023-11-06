return {
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstallAll' },
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'josa42/nvim-mason-install-all',
    },
    opts = {},
  },
}
