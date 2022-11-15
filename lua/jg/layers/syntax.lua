local layer = require('jg.lib.layer')

-- See: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local ts_install = 'all'
local ts_ignore = { 'vim', 'help', 'phpdoc', 'markdown' }
local ts_disable = { 'vim', 'help' }

layer.use({
  enabled = true,
  name = 'syntax-treesitter',

  requires = {
    { 'nvim-treesitter/nvim-treesitter', ['do'] = ':TSUpdate' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
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
    require('nvim-treesitter.configs').setup({
      ensure_installed = ts_install,
      ignore_install = ts_ignore,
      highlight = { enable = true, disable = ts_disable },
      indent = { enable = true, disable = ts_disable },
      autotag = { enable = false },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
          },
        },
      },
    })

    require('treesitter-context').setup({
      max_lines = 1,
      mode = 'topline',
      default = {
        'class',
        'function',
        'method',
      },
    })

    vim.cmd([[hi TreesitterContextBottom gui=underline guisp=#4B5263]])
    vim.cmd([[hi link TreesitterContext Normal]])
  end,
})

layer.use({
  name = 'syntax',

  requires = {
    'zhaozg/vim-diagram',
    'rhysd/vim-syntax-codeowners',
    'darfink/vim-plist',
    'josa42/vim-monkey-c',
    'jxnblk/vim-mdx-js',
  },
})
