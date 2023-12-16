return {
  {
    lazy = false,
    'nvim-telescope/telescope.nvim',

    dependencies = {
      {
        'josa42/nvim-telescope-config', --[[ dir = '~/github/josa42/nvim-telescope-config' ]]
      },
      'nvim-lua/plenary.nvim',
      'josa42/nvim-telescope-minimal-layout',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'josa42/nvim-telescope-mask',
      'itchyny/vim-gitbranch',
      {
        'josa42/nvim-telescope-workspaces', --[[ dir = '~/github/josa42/nvim-telescope-workspaces' ]]
      },
    },

    keys = function()
      local builtin = require('telescope.builtin')
      local commands = require('telescope-config').commands

      return {
        { '<c-p>', commands.global.find_files, desc = 'Find files' },

        -- select workspace
        { '<leader>ww', commands.workspace.select },

        -- Find File
        -- p  -> find
        -- wp -> find in workspace
        -- rp -> find in repo root
        { '<leader>p', commands.global.find_files },
        { '<leader>wp', commands.workspace.find_files },
        { '<leader>rp', commands.root.find_files },
        { '<leader>cp', commands.config.find_files, desc = 'Find config' },
        { '<leader>ap', commands.workflows.find_files, desc = 'Find workflows' },

        -- Find String
        -- f  -> search
        -- wf -> search in workspace
        -- rf -> search in repo root
        -- cf -> search in config
        { '<leader>f', commands.global.find_string, desc = 'Find string' },
        { '<leader>wf', commands.workspace.find_string },
        { '<leader>rf', commands.root.find_string },
        { '<leader>cf', commands.config.find_string, desc = 'Find string in config' },
        { '<leader>af', commands.workflows.find_string, desc = 'Find string in workflows' },

        -- File Browser
        -- b  -> file browser
        -- wb -> file browser in workspace
        -- rb -> file browser in repo root
        -- cb -> file browser in config
        -- { '<leader>b', commands.global.file_browser },
        -- { '<leader>wb', commands.workspace.file_browser },
        -- { '<leader>rb', commands.root.file_browser },
        -- { '<leader>cb', commands.config.file_browser },

        -- Git
        { '<leader>h', builtin.help_tags, desc = 'Find help' },
        { '<leader>gs', builtin.git_status, desc = 'Git status' },
        { '<leader>gb', builtin.git_bcommits, desc = 'Git buffer commits' },
        { '<leader>gl', builtin.git_commits, desc = 'Git commits' },
      }
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
