return {
  {
    'josa42/nvim-lsp-autoformat',

    event = { 'BufReadPost' },

    opts = {
      ['*.cjs'] = { 'null-ls' },
      ['*.mjs'] = { 'null-ls' },
      ['*.js'] = { 'null-ls' },
      ['*.json'] = { 'null-ls' },
      ['*.jsx'] = { 'null-ls' },
      ['*.md'] = { 'null-ls' },
      ['*.ts'] = { 'null-ls', 'tsserver' },
      ['*.tsx'] = { 'null-ls' },
      ['*.css'] = { 'stylelint_lsp' },
      ['*.lua'] = { 'null-ls' },
      ['Dockerfile'] = { 'dockerls' },
      ['*.swift'] = { 'null-ls' },
      ['*.go'] = { 'gopls' },
      ['*.tf'] = { 'null-ls' },
    },
    config = function(_, opts)
      require('jg.lsp-autoformat').setup(opts)
    end,
  },
}
