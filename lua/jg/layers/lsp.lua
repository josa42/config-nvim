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
  'sourcekit',
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
      border = { '↖', '─', '╮', '│', '╯', '─', '╰', '│' },
    })
  end,
})

layer.use({
  requires = {
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
    { 'n', 'K', vim.lsp.buf.hover },
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
    require('jg.lib.lsp.handlers').setup({
      diagnostics_ignored_codes = {
        typescript = {
          7016, --  Could not find a declaration file for module '<module>'.
          80001, -- File is a CommonJS module; it may be converted to an ES6 module.
          80002, -- This constructor function may be converted to a class declaration.
        },
      },
    })
    require('jg.layers.lsp.null-ls').setup()

    -- init servers
    local cmp = require('cmp_nvim_lsp')
    local installer = require('nvim-lsp-installer')

    installer.on_server_ready(function(server)
      local ok, setup = pcall(require, 'jg.layers.lsp.' .. server.name)
      server:setup(vim.tbl_extend('keep', ok and setup() or {}, {
        capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      }))
    end)

    -- install missing servers
    local servers = require('nvim-lsp-installer.servers')
    for _, name in ipairs(l.servers) do
      local _, server = servers.get_server(name)
      if not server:is_installed() then
        server:install()
      end
    end

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
      ['*.js'] = { 'null-ls' },
      ['*.json'] = { 'null-ls' },
      ['*.jsx'] = { 'null-ls' },
      ['*.ts'] = { 'null-ls', 'tsserver' },
      ['*.tsx'] = { 'null-ls' },
      ['*.css'] = { 'stylelint_lsp' },
      ['*.lua'] = { 'null-ls' },
      ['Dockerfile'] = { 'dockerls' },
      ['*.swift'] = { 'null-ls' },
      ['*.go'] = { 'gopls' },
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
    vim.cmd('hi! link FidgetTitle Title')
    vim.cmd('hi! link FidgetTask Normal')

    require('fidget').setup({
      text = {
        spinner = 'dots',
      },
    })
  end,
})
