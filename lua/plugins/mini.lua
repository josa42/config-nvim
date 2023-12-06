return {
  {
    'echasnovski/mini.nvim',
    dependencies = {
      'josa42/nvim-telescope-config',
    },

    keys = {
      -- File Browser
      -- b  -> file browser
      -- wb -> file browser in workspace
      -- rb -> file browser in repo root
      -- cb -> file browser in config
      {
        '<leader>b',
        function()
          require('mini.files').open()
        end,
      },
      {
        '<leader>wb',
        function()
          local workspace = require('jg.telescope-workspaces').get_current_workspace_path()
          require('mini.files').open(workspace)
        end,
      },

      {
        '<leader>rb',
        function()
          local root = vim.fs.find('.git', { upward = true, limit = 1 })[1]
          require('mini.files').open(root)
        end,
      },
      {
        '<leader>cb',
        function()
          local config_dir = require('config.paths').config_dir
          require('mini.files').open(config_dir)
        end,
      },
    },

    config = function()
      require('mini.files').setup({
        mappings = {
          close = 'q',
          go_in = 'l',
          go_in_plus = 'L',
          go_out = 'h',
          go_out_plus = 'H',
          reset = '<BS>',
          reveal_cwd = 'r',
          show_help = 'g?',
          synchronize = '=',
          trim_left = '<',
          trim_right = '>',
        },
      })
    end,
  },
}
