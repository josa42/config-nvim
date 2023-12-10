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
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
