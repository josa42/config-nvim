local tools = {
  'actionlint',
  'shellcheck',
  'editorconfig-checker',
}

local js_and_json = {
  'json',
  'jsonc',
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'svelte',
}

return {
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },

    config = function()
      -- run when mason is set up
      require('config.utils.mason').try_mason_install(tools)

      local utils = require('plugins.null-ls.utils')
      local null_ls = require('null-ls')

      null_ls.setup({
        debug = false, -- log: ~/.cache/nvim/null-ls.log
        sources = {
          -- eslint -> js; without json
          null_ls.builtins.diagnostics.eslint_d.with({
            runtime_condition = utils.condition_eslint_without_json,
            cwd = utils.eslint_root,
          }),

          -- eslint -> js and json
          null_ls.builtins.diagnostics.eslint_d.with({
            filetypes = js_and_json,
            runtime_condition = utils.condition_eslint_with_json,
            cwd = utils.eslint_root,
          }),

          -- action lint
          null_ls.builtins.diagnostics.actionlint.with({
            runtime_condition = function(params)
              return params.bufname:match('.*%.github/workflows/.*%.yml')
            end,
          }),

          null_ls.builtins.diagnostics.shellcheck,
        },
      })
    end,
  },
}
