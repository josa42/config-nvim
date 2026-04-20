local function try_require(module_name)
  local ok, module = pcall(require, module_name)
  return ok and module or nil
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  once = true,
  callback = function()
    local servers = require('lsp.servers').setup()
    require('lsp.handlers').setup()

    local mason_lspconfig = try_require('mason-lspconfig')
    if mason_lspconfig then
      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
        automatic_enable = false,
      })
    end
  end,
})
