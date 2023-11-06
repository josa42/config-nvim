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

      local has_mason, mason_lspconfig = pcall(require, 'mason-lspconfig')
      if has_mason then
        mason_lspconfig.setup_handlers({ setup_server })
        mason_lspconfig.setup({
          ensure_installed = servers,
          automatic_installation = true,
        })
      end

      setup_server('sourcekit')
    end,
  },
}
