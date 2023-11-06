local tools = {
  'actionlint',
  'fixjson',
  'shellcheck',
  'shfmt',
  'stylua',
  'editorconfig-checker',
  'eslint_d',
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
  'markdown',
}

return {
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },

    config = function()
      local utils = require('plugins.null-ls.utils')

      -- run when mason is set up
      utils.try_mason_install(tools)

      local null_ls = require('null-ls')

      null_ls.setup({
        debug = false, -- log: ~/.cache/nvim/null-ls.log
        sources = {
          -- eslint -> js; without json
          null_ls.builtins.diagnostics.eslint_d.with({
            runtime_condition = utils.condition_eslint_without_json,
            cwd = utils.eslint_root,
          }),
          null_ls.builtins.formatting.eslint_d.with({
            runtime_condition = utils.condition_eslint_without_json,
            cwd = utils.eslint_root,
          }),

          -- eslint -> js and json
          null_ls.builtins.diagnostics.eslint_d.with({
            filetypes = js_and_json,
            runtime_condition = utils.condition_eslint_with_json,
            cwd = utils.eslint_root,
          }),
          null_ls.builtins.formatting.eslint_d.with({
            filetypes = js_and_json,
            runtime_condition = utils.condition_eslint_with_json,
            cwd = utils.eslint_root,
          }),

          -- fixjson
          null_ls.builtins.formatting.fixjson.with({
            runtime_condition = utils.condition_not_eslint_with_json,
          }),

          -- fixjson
          null_ls.builtins.formatting.prettier.with({
            filetypes = { 'markdown' },
            runtime_condition = utils.condition_prettier_markdown,
          }),

          null_ls.builtins.formatting.stylua,

          null_ls.builtins.formatting.shfmt.with({
            extra_args = {
              '-i=2', -- indent: 0 for tabs (default), >0 for number of spaces
              '-bn', -- binary ops like && and | may start a line
              '-ci', -- switch cases will be indented
              '-sr', -- keep column alignment paddings
              '-kp', -- function opening braces are placed on a separate line
            },
          }),

          -- action lint
          null_ls.builtins.diagnostics.actionlint.with({
            runtime_condition = function(params)
              return params.bufname:match('.*%.github/workflows/.*%.yml')
            end,
          }),

          null_ls.builtins.diagnostics.shellcheck,

          null_ls.builtins.formatting.swiftformat,

          -- null_ls.builtins.diagnostics.editorconfig_checker.with({
          --   command = 'editorconfig-checker',
          --   runtime_condition = function(opt)
          --     return opt.bufname:find('/node_modules/') == nil and not opt.bufname:match('.*/yarn.lock$')
          --   end,
          -- }),

          null_ls.builtins.formatting.terraform_fmt,
          null_ls.builtins.code_actions.refactoring,
        },
      })
    end,

  }
}
