-- local map = vim.api.nvim_set_keymap
local layer = require('jg.lib.layer')
local lsp = require('jg.lib.lsp')
local au = require('jg.lib.autocmd')
local hi = require('jg.lib.highlight')

local handler = require('jg.lib.lsp.handler')

layer.use({
  require = {
    -- basic lsp config
    'neovim/nvim-lspconfig',

    -- nvim-cmp and sources
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'jose-elias-alvarez/null-ls.nvim',

    -- UI
    'folke/lsp-trouble.nvim',
    'glepnir/lspsaga.nvim',
    'onsails/lspkind-nvim',
    'ray-x/lsp_signature.nvim',
  },

  map = {
    { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
    { 'n', 'gD', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>' },
    { 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' },
    { 'n', __keymaps.goto_diagnostics_prev, '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>' },
    { 'n', __keymaps.goto_diagnostics_prev, '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>' },
    { 'n', __keymaps.goto_diagnostics_list, ':LspTroubleToggle lsp_document_diagnostics<cr>' },
    { 'n', 'gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
    { 'n', __keymaps.codeaction, '<cmd>lua vim.lsp.buf.code_action()<CR>' },
    { 'v', __keymaps.codeaction, "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>" },
    { 'n', __keymaps.format_buffer, '<cmd>lua vim.lsp.buf.formatting()<cr>' },
    { 'n', __keymaps.codelens_action, '<cmd>lua vim.lsp.codelens.run()<cr>' },
  },

  before = function()
    vim.cmd('set completeopt=menu,menuone,noselect') -- Set completeopt to have a better completion experience
    vim.cmd('set shortmess+=c') -- Avoid showing message extra message when using completion
    vim.cmd('set completeopt-=preview')
  end,

  after = function()
    require('lsp_signature').setup({
      use_lspsaga = false,
      floating_window = true,
      hint_enable = false,
      doc_lines = 0,
      handler_opts = {
        border = 'none',   -- double, single, shadow, none
      },
    })

    local setup = function(config, opts)
      config.setup(vim.tbl_extend('keep', opts or {}, {
        capabilities = lsp.make_client_capabilities(),
      }))
    end

    -- vim.lsp.set_log_level("debug")
    -- require('jg.layers.lsp.bcr-ls').setup(setup)
    -- require('jg.layers.lsp.emmet-ls').setup(setup)
    -- require('jg.layers.lsp.sourcekit').setup(setup)
    -- require('jg.layers.lsp.eslint').setup(setup)
    require('jg.layers.lsp.css').setup(setup)
    require('jg.layers.lsp.docker').setup(setup)
    require('jg.layers.lsp.go').setup(setup)
    require('jg.layers.lsp.html').setup(setup)
    require('jg.layers.lsp.json').setup(setup)
    require('jg.layers.lsp.lua').setup(setup)
    require('jg.layers.lsp.sh').setup(setup)
    require('jg.layers.lsp.typescript').setup(setup)
    require('jg.layers.lsp.viml').setup(setup)
    require('jg.layers.lsp.yaml').setup(setup)
    require('jg.layers.lsp.stylelint').setup(setup)
    require('jg.layers.lsp.null-ls').setup(setup)

    au.group('jg.layer.lsp', function(cmd)
      -- format on save
      cmd({ on = { 'BufWritePre' }, pattern = lsp.auto_formatting_pattern() }, function()
        if lsp.auto_formatting_enabled(vim.fn.expand('<afile>:e')) then
          lsp.buf_formatting()
        end
      end)

      -- Code lenses
      cmd({ on = { 'BufEnter', 'CursorHold', 'InsertLeave' }, pattern = '<buffer>' }, function()
        if lsp.anyClientSupports('textDocument/codeLens') then
          vim.lsp.codelens.refresh()
        end
      end)
    end)

    hi.link('LspCodeLens', 'Comment')
    hi.link('LspCodeLensSeparator', 'Comment')

    vim.lsp.handlers['textDocument/publishDiagnostics'] = handler.on_publish_diagnostics

    require('trouble').setup({
      mode = 'lsp_document_diagnostics',
      signs = {
        error = _G.__icons.diagnostic.error,
        warning = _G.__icons.diagnostic.warning,
        hint = _G.__icons.diagnostic.hint,
        information = _G.__icons.diagnostic.info,
      },
      icons = false,
      auto_close = true,
    })

    vim.fn.sign_define('DiagnosticSignError', { text = _G.__icons.diagnostic.error, texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = _G.__icons.diagnostic.warning, texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = _G.__icons.diagnostic.info, texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = _G.__icons.diagnostic.hint, texthl = 'DiagnosticSignHint' })

    vim.cmd('hi link CmpItemMenu Comment')

    local lspkind = require('lspkind')
    local cmp = require('cmp')
    cmp.setup({
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'vsnip' },
        { name = 'path' },
      }),
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      snippet = {
        expand = function(args)
          vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
        end,
      },
      formatting = {
        format = lspkind.cmp_format({
          with_text = true,
          menu = {
            buffer = '[buf]',
            nvim_lsp = '[lsp]',
            vsnip = '[snip]',
            nvim_lua = '[lua]',
            path = '[path]',
          },
        }),
      },
      mapping = {
        ['<C-Space>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.close()
          else
            cmp.complete()
          end
        end, {
          'i',
          'c',
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      experimental = {
        ghost_text = true,
      },
    })
  end,
})
