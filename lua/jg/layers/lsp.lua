local layer = require('jg.lib.layer')
local l = {}

l.servers = {
  'cssls',
  'html',
  'bashls',
  'vimls',
  'dockerls',
  'gopls',
  'jsonls',
  'sumneko_lua',
  'tsserver',
  'yamlls',
  'stylelint_lsp',
  'marksman',
  'terraformls',
  'tflint',
}

layer.use({
  requires = { 'rmagatti/goto-preview' },

  map = function()
    local goto_preview = require('goto-preview')
    return {
      { 'n', 'gpd', goto_preview.goto_preview_definition },
      { 'n', 'gpx', goto_preview.close_all_win },
    }
  end,

  setup = function()
    require('goto-preview').setup({
      border = { '↖', '─', '┐', '│', '┘', '─', '└', '│' },
    })
  end,
})

layer.use({
  requires = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    { 'jose-elias-alvarez/null-ls.nvim', dependencies = {
      'nvim-lua/plenary.nvim',
    } },
    'josa42/nvim-lsp-autoformat',
    'josa42/nvim-lsp-codelens',
  },

  map = {
    { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
    { 'n', 'gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>' },
    { 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' },
    { 'n', 'gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
    { 'n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>' },
    { 'v', '<leader>ac', "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>" },
    { 'n', '<leader>F', '<cmd>lua vim.lsp.buf.format()<cr>' },
    { 'n', '<leader>al', '<cmd>lua vim.lsp.codelens.run()<cr>' },
    {
      'n',
      'K',
      function()
        local clients = vim.tbl_filter(function(client)
          return client.supports_method('textDocument/hover')
        end, vim.tbl_values(vim.lsp.buf_get_clients()))

        if vim.tbl_isempty(clients) then
          vim.cmd.normal({ 'K', bang = true })
        else
          vim.lsp.buf.hover()
        end
      end,
    },
    { 'n', '<C-k>', vim.lsp.buf.signature_help },
  },

  commands = function()
    return {
      -- $ nvim --headless +'LspInstallAll | qa'
      LspInstallAll = {
        function()
          for _, server in ipairs(l.servers) do
            local ok = pcall(vim.cmd, 'silent LspInstall --sync ' .. server)
            print('         ' .. (ok and 'done' or 'failed'))
          end
        end,
        nargs = 0,
        bar = true,
      },
    }
  end,

  setup = function()
    local setup_server = function(name)
      local ok, setup = pcall(require, 'jg.layers.lsp.' .. name)
      require('lspconfig')[name].setup(vim.tbl_extend('keep', ok and setup() or {}, {
        capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      }))
    end

    require('jg.lib.lsp.handlers').setup()

    require('mason').setup({})
    require('mason-lspconfig').setup_handlers({ setup_server })
    require('mason-lspconfig').setup({
      ensure_installed = l.servers,
      automatic_installation = true,
    })

    setup_server('sourcekit')

    require('jg.layers.lsp.null-ls').setup()
    require('jg.lsp-codelens').setup()
    require('jg.lsp-autoformat').setup({
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
})

layer.use({
  enabled = true,

  requires = {
    'kosayoda/nvim-lightbulb',
  },

  setup = function()
    vim.api.nvim_create_augroup('nvim-lightbulb', { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'nvim-lightbulb',
      callback = require('nvim-lightbulb').update_lightbulb,
    })

    vim.fn.sign_define('LightBulbSign', { text = _G.__icons.action, texthl = 'DiagnosticSignAction' })

    require('nvim-lightbulb').setup({
      sign = {
        enabled = true,
        priority = 10,
      },
    })
  end,
})

layer.use({
  requires = {
    'j-hui/fidget.nvim',
  },

  setup = function()
    require('fidget').setup({
      text = {
        spinner = 'dots',
      },
    })
  end,
})
