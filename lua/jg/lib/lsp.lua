local M = {}

function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return capabilities
end

function M.anyClientSupports(method)
  local bufnr = vim.api.nvim_get_current_buf()
  local supported = false
  vim.lsp.for_each_buffer_client(bufnr, function(client)
    if client.supports_method(method) then
      supported = true
    end
  end)
  return supported
end

return M
