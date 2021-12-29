local layer = require('jg.lib.layer')
local l = {}

layer.use({
  require = {
    'williamboman/nvim-lsp-installer',
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',
    'josa42/nvim-lsp-autoformat',
    'josa42/nvim-lsp-codelens',
    'ray-x/lsp_signature.nvim',
  },

  map = {
    { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
    { 'n', 'gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>' },
    { 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' },
    { 'n', 'gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
    { 'n', __keymaps.codeaction, '<cmd>lua vim.lsp.buf.code_action()<CR>' },
    { 'v', __keymaps.codeaction, "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>" },
    { 'n', __keymaps.format_buffer, '<cmd>lua vim.lsp.buf.formatting()<cr>' },
    { 'n', __keymaps.codelens_action, '<cmd>lua vim.lsp.codelens.run()<cr>' },
  },

  after = function()
    require('jg.lib.lsp.handlers').setup()

    l.setup_providers({
      'css',
      'docker',
      'go',
      'html',
      'json',
      'lua',
      'sh',
      'typescript',
      'viml',
      'yaml',
      'stylelint',
      'null-ls',
    })

    require('lsp_signature').setup({
      use_lspsaga = false,
      floating_window = true,
      hint_enable = false,
      doc_lines = 0,
      handler_opts = {
        border = 'none', -- double, single, shadow, none
      },
    })

    require('jg.lsp-codelens').setup()
    require('jg.lsp-autoformat').setup({
      js = { 'null-ls' },
      json = { 'null-ls' },
      jsx = { 'null-ls' },
      ts = { 'null-ls' },
      tsx = { 'null-ls' },
      css = { 'stylelint_lsp' },
      lua = { 'stylua' },
      -- Fix josa42/nvim-lsp-autoformat to handle this
      -- Dockerfile = { 'dockerls' },
    })
  end,
})

function l.setup_providers(providers)
  for _, name in ipairs(providers) do
    require('jg.layers.lsp.' .. name).setup(function(server_name, opts)
      opts = opts or {}
      opts.cmd = nil
      l.server_setup(
        server_name,
        vim.tbl_extend('keep', opts or {}, {
          capabilities = l.make_client_capabilities(),
        })
      )
    end)
  end
end

function l.server_setup(server_name, opts)
  assert(type(server_name) == 'string', vim.inspect(server_name) .. ' should be a string!')

  local available, server = require('nvim-lsp-installer.servers').get_server(server_name)
  assert(available, 'Server ' .. server_name .. ' not found!')

  server:on_ready(function()
    server:setup(opts)
  end)

  if not server:is_installed() then
    server:install()
  end
end

function l.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return capabilities
end
