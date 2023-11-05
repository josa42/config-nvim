return {
  {
    'josa42/nvim-telescope-config',
    -- dir = '~/github/josa42/nvim-telescope-config',

    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'josa42/nvim-telescope-minimal-layout',

      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'josa42/nvim-telescope-mask',
      'nvim-telescope/telescope-file-browser.nvim',
      'itchyny/vim-gitbranch',
      'josa42/nvim-telescope-workspaces',

    },

    keys = function (plg)
      local builtin = require('telescope.builtin')
      local commands = require('telescope-config').commands
      local global = commands.global
      local root = commands.root
      local workspace = commands.workspace
      local config = commands.config

      return {
        { "<c-p>", commands.global.find_files, desc = "Find files" },

        -- select workspace
        { '<leader>ww', commands.workspace.select },

        -- Find File
        -- p  -> find
        -- wp -> find in workspace
        -- rp -> find in repo root
        { '<leader>p', global.find_files },
        { '<leader>wp', workspace.find_files },
        { '<leader>rp', root.find_files },
        { '<leader>cp', config.find_files, desc = 'Find config' },

        -- Find String
        -- f  -> search
        -- wf -> search in workspace
        -- rf -> search in repo root
        -- cf -> search in config
        { '<leader>f', global.find_string, desc = 'Find string' },
        { '<leader>wf', workspace.find_string },
        { '<leader>rf', root.find_string },
        { '<leader>cf', config.find_string, desc = 'Find string in config' },

        -- File Browser
        -- b  -> file browser
        -- wb -> file browser in workspace
        -- rb -> file browser in repo root
        -- cb -> file browser in config
        { '<leader>b', global.file_browser },
        { '<leader>wb', workspace.file_browser },
        { '<leader>rb', root.file_browser },
        { '<leader>cb', config.file_browser },

        -- Git
        {'<leader>h', builtin.help_tags, desc = 'Find help' },
        {'<leader>gs', builtin.git_status, desc = 'Git status' },
        {'<leader>gb', builtin.git_bcommits, desc = 'Git buffer commits' },
        {'<leader>gl', builtin.git_commits, desc = 'Git commits' },
      }
    end,

    config = true,
    opts = {
      icons = {
        dir_icon = require('config.signs').fs.dir,
      }
    },

--    config = function()
--      local telescope = require('telescope')
--
--      telescope.load_extension('minimal_layout')
--
--      local function picker_default_opts(pickers)
--        for key in pairs(builtin) do
--          pickers[key] = default_opts(pickers[key])
--        end
--        return pickers
--      end
--
--      telescope.setup({
--        defaults = {
--          layout_strategy = 'minimal',
--          layout_config = {
--            prompt_position = 'top',
--          },
--          sorting_strategy = 'ascending',
--        },
--
--        pickers = picker_default_opts({
--          find_files = {
--            hidden = true,
--            entry_maker = make_gen_from_file(),
--          },
--          live_grep = {
--            additional_args = function()
--              return { '--hidden' }
--            end,
--            preview = { hide_on_startup = false },
--          },
--          help_tags = {
--            preview = { hide_on_startup = false },
--          },
--          git_bcommits = {
--            preview = { hide_on_startup = false },
--          },
--          git_commits = {
--            preview = { hide_on_startup = false },
--          },
--          highlights = {
--            preview = { hide_on_startup = false },
--          },
--          jumplist = {
--            preview = { hide_on_startup = false },
--          },
--        }),
--
--      })
--    end,
  },
}
