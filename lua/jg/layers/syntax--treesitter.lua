local layer = require('jg.lib.layer')

layer.use({
  enabled = false,
  requires = { { 'nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' } } },

  setup = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      highlight = { enable = true },
      indent = { enable = false },
      autotag = { enable = false },
    })
  end,
})
