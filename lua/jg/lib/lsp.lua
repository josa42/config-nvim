local util = vim.lsp.util

local M = {}

local formatting_clients_defaults = {
  js = { 'null-ls' },
  json = { 'null-ls' },
  jsx = { 'null-ls' },
  ts = { 'null-ls' },
  tsx = { 'null-ls' },
  css = { 'stylelint_lsp' },
  lua = { 'stylua' },
}

function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return capabilities
end

local function select_client(method, client_names)
  local clients = vim.tbl_filter(function(client)
    return client.supports_method(method)
  end, vim.tbl_values(
    vim.lsp.buf_get_clients()
  ))

  table.sort(clients, function(a, b)
    return a.name < b.name
  end)

  if client_names ~= nil then
    for _, client_name in ipairs(client_names) do
      local client = vim.tbl_filter(function(client)
        return client.name == client_name
      end, clients)[1]

      if client ~= nil then
        return client
      end
    end
  end

  return clients[1]
end

function M.auto_formatting_pattern()
  local pattern = {}
  for ext in pairs(vim.g.formatting_clients or formatting_clients_defaults) do
    table.insert(pattern, '*.' .. ext)
  end

  return pattern
end

function M.auto_formatting_enabled(ext)
  for v in pairs(vim.g.formatting_clients or formatting_clients_defaults) do
    if v == ext then
      return true
    end
  end

  return false
end

function M.formatting_clients(ext)
  for k, clients in pairs(vim.g.formatting_clients or formatting_clients_defaults) do
    if k == ext then
      return clients
    end
  end
end

function M.buf_formatting(client_names)
  client_names = client_names or M.formatting_clients(vim.fn.expand('%:e'))

  local client = select_client('textDocument/formatting', client_names)
  if client == nil then
    return
  end

  local params = util.make_formatting_params(nil)
  local bufnr = vim.api.nvim_get_current_buf()

  local response = client.request_sync('textDocument/formatting', params, 1000, bufnr)
  if response ~= nil and response.result ~= nil then
    util.apply_text_edits(response.result, bufnr)
  end
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
