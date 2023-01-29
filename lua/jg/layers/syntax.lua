local layer = require('jg.lib.layer')

-- See: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local ts_install = 'all'
local ts_disable = { 'help' }

local parser_install_dir = vim.fn.stdpath('data') .. '/tree-sitter'

layer.use({
  enabled = true,
  name = 'syntax-treesitter',

  requires = {
    { 'nvim-treesitter/nvim-treesitter', lazy = true, event = 'BufReadPre', priority = 100 },
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

    vim.opt.runtimepath:append(parser_install_dir)

    -- use bash parser for zsh
    require('nvim-treesitter.parsers').filetype_to_parsername.zsh = 'bash'

    configs.setup({
      ensure_installed = ts_install,
      ignore_install = ts_disable,
      parser_install_dir = parser_install_dir,

      highlight = { enable = true, disable = ts_disable },
      indent = { enable = true, disable = ts_disable },
      autotag = { enable = false },
    })

    -- Remove conceal for markdown code fences
    pcall(function()
      local file = vim.treesitter.query.get_query_files('markdown', 'highlights')[1]
      local content = require('jg.lib.fs')
        .read(file)
        :gsub('%(%[\n  %(info_string%)\n  %(fenced_code_block_delimiter%)\n%] @conceal.*%)%)\n', '++++')
      vim.treesitter.query.set_query('markdown', 'highlights', content)
    end)
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
    'mityu/vim-applescript',
    'fladson/vim-kitty',
  },
})
