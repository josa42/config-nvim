return {
  {
    'josa42/nvim-lsp-autoformat',

    event = { 'BufReadPost' },
    opts = {
      ['*.css'] = { 'stylelint_lsp' },
      ['Dockerfile'] = { 'dockerls' },
      ['*.go'] = { 'gopls' },
    },
    config = function(_, opts)
      require('jg.lsp-autoformat').setup(opts)
    end,
  },
}
