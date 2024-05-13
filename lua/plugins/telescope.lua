return {
  {
    lazy = false,
    'nvim-telescope/telescope.nvim',

    dependencies = {
      {
        'josa42/nvim-telescope-config',
        -- dir = '~/github/josa42/nvim-telescope-config',
      },
      'nvim-lua/plenary.nvim',
      'josa42/nvim-telescope-minimal-layout',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'josa42/nvim-telescope-mask',
      'itchyny/vim-gitbranch',
      {
        'josa42/nvim-telescope-workspaces',
        -- dir = '~/github/josa42/nvim-telescope-workspaces',
      },
    },

    keys = function()
      local builtin = require('telescope.builtin')
      local commands = require('telescope-config').commands

      local keys = {
        { '<c-p>', commands.global.find_files, desc = 'Find files' },

        -- select workspace
        { '<leader>ww', commands.workspace.select },

        -- Help
        { '<leader>h', builtin.help_tags, desc = 'Find help' },

        -- Git
        { '<leader>gs', builtin.git_status, desc = 'Git status' },
        { '<leader>gf', builtin.git_bcommits, desc = 'Git buffer commits' },
        { '<leader>gl', builtin.git_commits, desc = 'Git commits' },
      }

      local map = require('config.utils.map')
      local ts = require('telescope-config')

      -- Find File
      -- p  -> find
      -- wp -> find in workspace
      -- rp -> find in repo root
      -- cp -> find in config
      -- ap -> find in github workflows
      map.append_keys(keys, 'p', 'Find file', ts.find_files)

      -- Find String
      -- f  -> search
      -- wf -> search in workspace
      -- rf -> search in repo root
      -- cf -> search in config
      -- ap -> search in github workflows
      map.append_keys(keys, 'f', 'Find string', ts.find_string)
      map.append_keys(keys, 'bf', 'Find string in buffer', builtin.current_buffer_fuzzy_find)

      return keys
    end,

    -- config = true,
    opts = {
      icons = {
        dir_icon = require('config.signs').fs.dir,
      },
    },

    config = function(pkg, opts)
      require('telescope-config').setup(opts)
    end,
  },
}
