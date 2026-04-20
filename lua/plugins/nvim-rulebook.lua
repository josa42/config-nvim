return {
  {
    enable = true,
    'chrisgrieser/nvim-rulebook',
    opts = {},

    -- TODO always forget about these keymaps, not sure if they are useful at all
    keys = {
      {
        '<leader>di', -- diagnostic ignore
        function()
          require('rulebook').ignoreRule()
        end,
        mode = 'n',
      },
      -- {
      --   '<leader>ll',
      --   function()
      --     require('rulebook').lookupRule()
      --   end,
      --   mode = 'n',
      -- },
      -- {
      --   '<leader>lf',
      --   function()
      --     require('rulebook').suppressFormatter()
      --   end,
      --   mode = { 'n', 'x' },
      -- },
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
