return {
  {
    'chrisgrieser/nvim-rulebook',
    opts = {},

    keys = {
      {
        '<leader>ri',
        function()
          require('rulebook').ignoreRule()
        end,
        mode = 'n',
      },
      {
        '<leader>rl',
        function()
          require('rulebook').lookupRule()
        end,
        mode = 'n',
      },
      {
        '<leader>rf',
        function()
          require('rulebook').suppressFormatter()
        end,
        mode = { 'n', 'x' },
      },
    },
    config = function(opts)
      require('rulebook').setup(opts)

      vim.diagnostic.config({
        virtual_text = {
          suffix = function(diag)
            return require('rulebook').hasDocs(diag) and '  ' or ''
          end,
        },
      })
    end,
  },
}
