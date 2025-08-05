local function try_require(module_name)
  local ok, module = pcall(require, module_name)
  return ok and module or nil
end

local function supports(capability)
  local clients = vim.tbl_filter(function(client)
    return client.supports_method(capability)
  end, vim.tbl_values(vim.lsp.get_clients()))

  return not vim.tbl_isempty(clients)
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'b0o/SchemaStore.nvim' },

    event = { 'BufRead' },

    keys = {
      { 'gd', vim.lsp.buf.definition },
      { 'gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>' },
      { '<space>rn', vim.lsp.buf.rename },
      { 'gH', vim.lsp.buf.signature_help },
      { '<c-h>', vim.lsp.buf.signature_help, mode = 'i' },
      { '<leader>la', vim.lsp.buf.code_action },
      { '<leader>la', vim.lsp.buf.code_action, mode = 'v' },
      { '<leader>F', vim.lsp.buf.format },
      { '<leader>ll', vim.lsp.codelens.run },
      {
        'K',
        function()
          if supports('textDocument/hover') then
            vim.lsp.buf.hover()
          else
            vim.cmd.normal({ 'K', bang = true })
          end
        end,
      },
    },

    config = function()
      local servers = require('lsp.servers').setup()
      require('lsp.handlers').setup()

      local mason_lspconfig = try_require('mason-lspconfig')
      if mason_lspconfig then
        -- mason_lspconfig.setup_handlers({ setup_server })
        mason_lspconfig.setup({
          ensure_installed = servers,
          automatic_installation = true,
          automatic_enable = false,
        })
      end
    end,
  },
}
