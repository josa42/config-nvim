-- local map = vim.api.nvim_set_keymap
local layer = require('jg.lib.layer')
local lsp = require('jg.lib.lsp')
local au = require('jg.lib.autocmd')
local hi = require('jg.lib.highlight')

local l = {}

layer.use({
  require = {
    -- basic lsp config
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',
    'josa42/nvim-lsp-autoformat',
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

    au.group('jg.layer.lsp', function(cmd)
      -- Code lenses
      cmd({ on = { 'BufEnter', 'CursorHold', 'InsertLeave' }, pattern = '<buffer>' }, function()
        if lsp.anyClientSupports('textDocument/codeLens') then
          vim.lsp.codelens.refresh()
        end
      end)
    end)

    hi.link('LspCodeLens', 'Comment')
    hi.link('LspCodeLensSeparator', 'Comment')

    require('lsp_signature').setup({
      use_lspsaga = false,
      floating_window = true,
      hint_enable = false,
      doc_lines = 0,
      handler_opts = {
        border = 'none', -- double, single, shadow, none
      },
    })

    require('jg.lsp-autoformat').setup({
      js = { 'null-ls' },
      json = { 'null-ls' },
      jsx = { 'null-ls' },
      ts = { 'null-ls' },
      tsx = { 'null-ls' },
      css = { 'stylelint_lsp' },
      lua = { 'stylua' },
    })
  end,
})

function l.setup_providers(providers)
  for _, name in ipairs(providers) do
    require('jg.layers.lsp.' .. name).setup(function(config, opts)
      config.setup(vim.tbl_extend('keep', opts or {}, {
        capabilities = lsp.make_client_capabilities(),
      }))
    end)
  end
end
