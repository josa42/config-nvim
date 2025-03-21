return {
  {
    enabled = true,
    'pmizio/typescript-tools.nvim',

    events = { 'VeryLazy' },

    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },

    config = function()
      require('config.utils.mason').try_mason_install({
        'typescript-language-server',
      })

      local api = require('typescript-tools.api')
      require('typescript-tools').setup({
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayVariableTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },

        handlers = {
          ['textDocument/publishDiagnostics'] = api.filter_diagnostics({
            -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            7016, --  Could not find a declaration file for module '<module>'.
            80001, -- File is a CommonJS module; it may be converted to an ES6 module.
            80002, -- This constructor function may be converted to a class declaration.
          }),
        },
      })
    end,
  },
}
