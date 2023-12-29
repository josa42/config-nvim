return {
  {
    'mfussenegger/nvim-lint',
    config = function()
      -- run when mason is set up
      require('config.utils.mason').try_mason_install({
        'actionlint',
        'shellcheck',
        'editorconfig-checker',
      })

      require('lint').linters_by_ft = {
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        json = { 'eslint_d' },
        sh = { 'shellcheck' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        yaml = { 'actionlint' },
      }

      local conditions = {
        actionlint = function(ctx)
          return ctx.filename:match('.*%.github/workflows/.*%.yml') ~= nil
        end,
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged' }, {
        group = vim.api.nvim_create_augroup('config.plugins.lint', { clear = true }),
        callback = function(opts)
          local lint = require('lint')
          local ctx = {
            filename = opts.file,
          }

          local names = vim.tbl_filter(function(name)
            return conditions[name] == nil or conditions[name](ctx)
          end, lint.linters_by_ft[vim.bo.filetype] or {})

          lint.try_lint(names)
        end,
      })
    end,
  },
}
