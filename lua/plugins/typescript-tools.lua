return {
  {
    enabled = true,
    'pmizio/typescript-tools.nvim',

    events = { 'VeryLazy' },

    dependencies = { 'nvim-lua/plenary.nvim' },

    opts = function()
      local api = require('typescript-tools.api')

      return {
        settings = {
          separate_diagnostic_server = true,
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayVariableTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            disableLineTextInReferences = true,
            organizeImportsIgnoreCase = true,
          },
          tsserver_format_options = {
            indentSize = 2,
            tabSize = 2,
            indentStyle = 'space',
          },
        },

        handlers = {
          ['textDocument/publishDiagnostics'] = api.filter_diagnostics({
            -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            -- 7016, --  Could not find a declaration file for module '<module>'.
            80001, -- File is a CommonJS module; it may be converted to an ES6 module.
            80002, -- This constructor function may be converted to a class declaration.
          }),
        },
      }
    end,

    init = function()
      require('config.utils.mason').try_mason_install({
        'typescript-language-server',
      })
    end,
  },
}
