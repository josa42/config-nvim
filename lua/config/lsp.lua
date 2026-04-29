local l = {}
-- server names have to match mason-lspconfig names for automatic installation to work
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
  'ruff',
  'pyright',
  -- 'snyk_ls',
}

local ignore = {
  'ts_ls',
}

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  once = true,
  callback = function()
    for _, key in pairs(servers) do
      l.setup_server(key)
    end

    l.setup_server('sourcekit')

    vim.diagnostic.config({
      update_in_insert = true,
      virtual_text = false,
    })

    local mason_lspconfig = l.try_require('mason-lspconfig')
    if mason_lspconfig then
      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
        automatic_enable = false,
      })
    end
  end,
})

function l.try_require(module_name)
  local ok, module = pcall(require, module_name)
  return ok and module or nil
end

function l.setup_server(name)
  if vim.tbl_contains(ignore, name) then
    return
  end

  local get_opts = l.try_require('lsp.servers.' .. name)
  local opts = get_opts ~= nil and get_opts() or {}

  local cmp_nvim_lsp = l.try_require('cmp_nvim_lsp')
  if cmp_nvim_lsp ~= nil then
    opts = vim.tbl_extend('keep', opts, {
      capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    })
  end

  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
