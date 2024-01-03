return {
  {
    'mfussenegger/nvim-lint',
    config = function()
      -- run when mason is set up
      require('config.utils.mason').try_mason_install({
        'eslint_d',
        'actionlint',
        'shellcheck',
        'editorconfig-checker',
      })

      local lint = require('lint')
      local c = require('config.utils.find')

      lint.linters_by_ft = {
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        json = { 'eslint_d' },
        sh = { 'shellcheck' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        yaml = { 'actionlint' },
      }

      local options = {
        actionlint = {
          condition = function(ctx)
            return ctx.filename:match('.*%.github/workflows/.*%.yml') ~= nil
          end,
        },
        eslint_d = {
          cwd = c.any(c.root_eslintrc),
        },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged' }, {
        group = vim.api.nvim_create_augroup('config.plugins.lint', { clear = true }),
        callback = function(opts)
          local lint = require('lint')
          local ctx = {
            filename = opts.file,
          }

          for _, name in ipairs(lint.linters_by_ft[vim.bo.filetype] or {}) do
            local opts = options[name] or {}
            if opts.condition == nil or opts.condition(ctx) then
              local cwd = opts.cwd and opts.cwd(nil, ctx) or vim.fn.getcwd()
              lint.try_lint(name, { cwd = cwd })
            end
          end
        end,
      })
    end,
  },
}
