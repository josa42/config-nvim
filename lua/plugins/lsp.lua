local servers = {
  'cssls',
  'html',
  'bashls',
  'vimls',
  'dockerls',
  'gopls',
  'jsonls',
  'lua_ls',
  'tsserver',
  'yamlls',
  'stylelint_lsp',
  'terraformls',
  'tflint',
}

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufRead' },
    cmd = { 'MasonInstallAll' },
    dependencies = {
      {
        'williamboman/mason.nvim',
        dependencies = {
          'williamboman/mason-lspconfig.nvim',
          'josa42/nvim-mason-install-all',
        },
      },
      { 'jose-elias-alvarez/null-ls.nvim', dependencies = {
        'nvim-lua/plenary.nvim',
      } },
      'josa42/nvim-lsp-codelens',
      'josa42/nvim-lsp-autoformat',
    },

    keys = {
      { 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
      { 'gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>' },
      { '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' },
      { 'gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
      { '<leader>ac', vim.lsp.buf.code_action },
      { '<leader>ac', vim.lsp.buf.code_action, mode = 'v' },
      { '<leader>F', '<cmd>lua vim.lsp.buf.format()<cr>' },
      { '<leader>al', '<cmd>lua vim.lsp.codelens.run()<cr>' },
      {
        'K',
        function()
          local clients = vim.tbl_filter(function(client)
            return client.supports_method('textDocument/hover')
          end, vim.tbl_values(vim.lsp.get_clients()))

          if vim.tbl_isempty(clients) then
            vim.cmd.normal({ 'K', bang = true })
          else
            vim.lsp.buf.hover()
          end
        end,
      },
      { '<C-k>', vim.lsp.buf.signature_help },
    },

    config = function()
      local setup_server = function(name)
        local ok, setup = pcall(require, 'lsp.servers.' .. name)
        local ok_cap, capabilities = pcall(function()
          return require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
        end)

        require('lspconfig')[name].setup(vim.tbl_extend('keep', ok and setup() or {}, {
          capabilities = ok_cap and capabilities or nil,
        }))
      end

      require('lsp.handlers').setup()

      require('mason').setup({})
      require('mason-lspconfig').setup_handlers({ setup_server })
      require('mason-lspconfig').setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      setup_server('sourcekit')

      require('jg.lsp-codelens').setup()

      require('lsp.servers.null-ls').setup()
      require('jg.lsp-autoformat').setup({
        ['*.cjs'] = { 'null-ls' },
        ['*.mjs'] = { 'null-ls' },
        ['*.js'] = { 'null-ls' },
        ['*.json'] = { 'null-ls' },
        ['*.jsx'] = { 'null-ls' },
        ['*.md'] = { 'null-ls' },
        ['*.ts'] = { 'null-ls', 'tsserver' },
        ['*.tsx'] = { 'null-ls' },
        ['*.css'] = { 'stylelint_lsp' },
        ['*.lua'] = { 'null-ls' },
        ['Dockerfile'] = { 'dockerls' },
        ['*.swift'] = { 'null-ls' },
        ['*.go'] = { 'gopls' },
        ['*.tf'] = { 'null-ls' },
      })
    end,
  },
}
