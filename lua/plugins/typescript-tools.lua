return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('config.utils.mason').try_mason_install({
        'typescript-language-server',
      })
      require('typescript-tools').setup({})
    end,
  },
}
