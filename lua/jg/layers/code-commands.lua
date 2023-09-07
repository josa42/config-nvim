local layer = require('jg.lib.layer')

layer.use({
  enabled = false,
  requires = {
    -- { 'josa42/nvim-code-commands' },
    { 'josa42/nvim-code-commands', dir = os.getenv('HOME') .. '/github/josa42/nvim-code-commands' },
  },

  setup = function()
    local cmds = require('code-commands')
    local c = require('code-commands.conditions')

    local has_eslint_with_json = c.if_all(c.find_node_package('jsonc-eslint-parser'), c.find_node_bin('eslint'))

    cmds.register({
      filetypes = { 'lua' },
      formatters = {
        c.condition(cmds.formatters.stylua, c.find_up('stylua.toml')),
      },
    })

    cmds.register({
      filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
      formatters = c.one({
        c.condition(cmds.formatters.eslint_d, c.find_node_bin('eslint')),
        cmds.formatters.prettier,
      }),
      linters = {
        c.condition(cmds.linters.eslint_d, c.find_node_bin('eslint')),
        cmds.linters.typos,
      },
    })

    cmds.register({
      filetypes = { 'sh' },
      formatters = { cmds.formatters.shfmt },
      linters = { cmds.linters.shellcheck },
    })

    cmds.register({
      filetypes = { 'yaml' },
      linters = {
        c.condition(cmds.linters.actionlint, function(opts)
          return vim.api.nvim_buf_get_name(opts.buffer):find('%.github[\\/]workflows') ~= nil
        end),
      },
    })

    cmds.register({
      filetypes = { 'swift' },
      formatters = { cmds.formatters.swiftformat },
    })

    cmds.register({
      filetypes = { 'json', 'jsonc' },
      formatters = c.one({
        c.condition(cmds.formatters.eslint_d, has_eslint_with_json),
        cmds.formatters.fixjson,
      }),
    })

    cmds.register({
      filetypes = { 'markdown' },
      linters = { cmds.linters.typos },
      formatters = {
        c.condition(cmds.formatters.prettier, function(api)
          return os.getenv('NVIMV_ENABLE_PRETTIER_MARKDOWN') == '1' and api.find_up('node_modules/.bin/prettier')
        end),
      },
    })

    cmds.register({
      filetypes = { 'go' },
      formatters = {
        cmds.formatters.lsp.using('gopls'),
      },
    })

    cmds.register({
      filetypes = { 'css' },
      formatters = c.one({
        cmds.formatters.lsp.using('stylelint_lsp'),
        cmds.formatters.prettier,
      }),
    })

    cmds.register({
      filetypes = { 'dockerfile' },
      formatters = {
        cmds.formatters.lsp.using('dockerls'),
      },
    })
  end,
})
