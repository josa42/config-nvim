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
    'jose-elias-alvarez/null-ls.nvim',

    -- UI
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
    require('lsp_signature').setup({
      use_lspsaga = false,
      floating_window = true,
      hint_enable = false,
      doc_lines = 0,
      handler_opts = {
        border = 'none', -- double, single, shadow, none
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
    vim.lsp.handlers['textDocument/declaration'] = handler.on_location
    vim.lsp.handlers['textDocument/definition'] = handler.on_location
    vim.lsp.handlers['textDocument/typeDefinition'] = handler.on_location
    vim.lsp.handlers['textDocument/implementation'] = handler.on_location

      },
    })
  end,
})
