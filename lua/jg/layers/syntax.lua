local layer = require('jg.lib.layer')

-- See: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local ts_install = 'all'
local ts_ignore = { 'vim', 'phpdoc', 'markdown' }
local ts_disable = { 'vim' }

layer.use({
  enabled = true,
  name = 'syntax-treesitter',

  requires = {
    { 'nvim-treesitter/nvim-treesitter', ['do'] = ':TSUpdate' },
    { 'nvim-treesitter/playground' },
  },

  map = {
    {
      'n',
      '<space>t',
      ':TSHighlightCapturesUnderCursor<CR>',
    },
  },

  setup = function()
    local configs = require('nvim-treesitter.configs')

    configs.setup({
      ensure_installed = ts_install,
      ignore_install = ts_ignore,
      highlight = { enable = true, disable = ts_disable },
      indent = { enable = true, disable = ts_disable },
      autotag = { enable = false },
    })
  end,
})

layer.use({
  name = 'syntax',

  requires = {
    'zhaozg/vim-diagram',
    'rhysd/vim-syntax-codeowners',
    'darfink/vim-plist',
    'josa42/vim-monkey-c',
  },
})
