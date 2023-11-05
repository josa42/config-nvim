-- local layer = require('jg.lib.layer')

-- See: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local ts_install = 'all'
local ts_disable = { 'help' }

local parser_install_dir = vim.fn.stdpath('data') .. '/tree-sitter'

return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    lazy = true,
    -- event = 'BufReadPre',
    -- priority = 100,

    build = ":TSUpdate",
    event = { "BufReadPre" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },

    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,

    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/playground',
    },

    keys = {
      {
        '<space>t',
        ':TSHighlightCapturesUnderCursor<CR>',
      },
    },

    config = function()
      -- prepend path to make sure bundled parsers are not used
      vim.opt.runtimepath:prepend(vim.fs.joinpath(vim.fn.stdpath('data'), 'tree-sitter'))

      local configs = require('nvim-treesitter.configs')

      vim.opt.runtimepath:append(parser_install_dir)

      -- use bash parser for zsh
      vim.treesitter.language.register('bash', 'zsh')

      configs.setup({
        ensure_installed = ts_install,
        ignore_install = ts_disable,
        parser_install_dir = parser_install_dir,

        highlight = { enable = true, disable = ts_disable },
        indent = { enable = true, disable = ts_disable },
        autotag = { enable = false },
        context_commentstring = { enable = true },
      })

      -- Remove conceal for markdown code fences
      pcall(function()
        vim.treesitter.query.set = vim.treesitter.query.set or vim.treesitter.query.set_query
        vim.treesitter.query.get_files = vim.treesitter.query.get_files or vim.treesitter.query.get_query_files

        local file = vim.treesitter.query.get_files('markdown', 'highlights')[1]
        local content = require('jg.lib.fs')
        vim.treesitter.language.r
        :gsub('%(%[\n  %(info_string%)\n  %(fenced_code_block_delimiter%)\n%] @conceal.*%)%)\n', '++++')
        vim.treesitter.query.set('markdown', 'highlights', content)
      end)
    end,
  },

  -- {
  --   "windwp/nvim-ts-autotag",
  --   event = { "BufReadPre" },
  --   opts = {},
  -- },
}
