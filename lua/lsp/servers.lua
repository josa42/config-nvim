local M = {}

local servers = {
  'cssls',
  'html',
  'bashls',
  'vimls',
  'dockerls',
  'gopls',
  'jsonls',
  'lua_ls',
  'ts_ls',
  'yamlls',
  'stylelint_lsp',
  'terraformls',
  'tflint',
  'eslint',
  -- 'snyk_ls',
}

local ignore = {
  'ts_ls',
}

local function try_require(module_name)
  local ok, module = pcall(require, module_name)
  return ok and module or nil
end

function M.setup()
  local setup_server = function(name)
    if vim.tbl_contains(ignore, name) then
      return
    end

    local get_opts = try_require('lsp.servers.' .. name)
    local opts = get_opts ~= nil and get_opts() or {}

    -- Add capebilities for nvim-cmp if available
    local cmp_nvim_lsp = try_require('cmp_nvim_lsp')
    if cmp_nvim_lsp ~= nil then
      opts = vim.tbl_extend('keep', opts, {
        capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      })
    end

    if vim.fn.has('nvim-0.11') == 1 then
      vim.lsp.config(name, opts)
      vim.lsp.enable(name)
    else
      require('lspconfig')[name].setup(opts)
    end
  end

  for _, key in pairs(servers) do
    setup_server(key)
  end

  setup_server('sourcekit')

  return servers
end

return M
