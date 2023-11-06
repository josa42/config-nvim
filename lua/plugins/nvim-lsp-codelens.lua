return {
  {
    'josa42/nvim-lsp-codelens',

    event = { 'BufReadPost' },
    opts = {},
    config = function(_, opts)
      require('jg.lsp-codelens').setup(opts)
    end,
  },
}
