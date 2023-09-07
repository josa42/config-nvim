local layer = require('jg.lib.layer')
local signs = require('jg.signs')

local l = {}

local use_null_ls = true

l.servers = {
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
    'josa42/nvim-lsp-codelens',
    use_null_ls and 'josa42/nvim-lsp-autoformat' or nil,
    -- 'josa42/nvim-markdown-preview',
  },

  map = {
    { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
    { 'n', 'gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>' },
    { 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' },
    { 'n', 'gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
    { 'n', '<leader>ac', vim.lsp.buf.code_action },
    { 'v', '<leader>ac', vim.lsp.buf.code_action },
    { 'n', '<leader>F', '<cmd>lua vim.lsp.buf.format()<cr>' },
    { 'n', '<leader>al', '<cmd>lua vim.lsp.codelens.run()<cr>' },
    {
      'n',
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
    { 'n', '<C-k>', vim.lsp.buf.signature_help },
  },

  commands = function()
    return {
      -- $ nvim --headless -c 'MasonInstallAll' -c qall
      MasonInstallAll = function()
        local running = 0
        local done = function()
          running = running - 1
        end

        for _, pkg in ipairs(require('mason-registry').get_installed_packages()) do
          running = running + 1

          pkg:check_new_version(function(new_available)
            if new_available then
              pkg:install():on('closed', done)
            else
              done()
            end
          end)
        end

        vim.wait(10000, function()
          return running == 0
        end)
      end,
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

    -- setup_server('markdown_preview_ls')
    -- require('markdown-preview').create_update_autocmd()

    setup_server('sourcekit')

    require('jg.lsp-codelens').setup()

    if use_null_ls then
      require('jg.layers.lsp.null-ls').setup()
      require('jg.lsp-autoformat').setup({
        ['*.cjs'] = { 'null-ls' },
        ['*.mjs'] = { 'null-ls' },
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
    end
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

    vim.fn.sign_define('LightBulbSign', { text = signs.action, texthl = 'DiagnosticSignAction' })

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
    { 'j-hui/fidget.nvim', tag = 'legacy' },
  },

  setup = function()
    require('fidget').setup({
      text = {
        spinner = 'dots',
      },
    })
  end,
})
