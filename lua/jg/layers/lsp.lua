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

    l.setup_servers({
      'cssls',
      'html',
      'bashls',
      'vimls',

      dockerls = require('jg.layers.lsp.dockerls'),
      gopls = require('jg.layers.lsp.gopls'),
      jsonls = require('jg.layers.lsp.jsonls'),
      sumneko_lua = require('jg.layers.lsp.sumneko_lua'),
      tsserver = require('jg.layers.lsp.tsserver'),
      yamlls = require('jg.layers.lsp.yamlls'),
      stylelint_lsp = require('jg.layers.lsp.stylelint_lsp'),
      null_ls = require('jg.layers.lsp.null-ls'),
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

function l.setup_servers(providers)
  for i, name in ipairs(providers) do
    providers[i] = nil
    providers[name] = function(setup)
      setup(name)
    end
  end

  for name, setup in pairs(providers) do
    setup(function(name, opts)
      opts = opts or {}
      opts.cmd = nil
      l.setup_server(
        name,
        vim.tbl_extend('keep', opts or {}, {
          capabilities = l.make_client_capabilities(),
        })
      )
    end)
  end
end

function l.setup_server(name, opts)
  assert(type(name) == 'string', vim.inspect(name) .. ' should be a string!')

  local available, server = require('nvim-lsp-installer.servers').get_server(name)
  assert(available, 'Server ' .. name .. ' not found!')

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
