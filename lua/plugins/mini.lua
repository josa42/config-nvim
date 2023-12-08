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
          local root = vim.fs.dirname(vim.fs.find('.git', { upward = true, limit = 1 })[1])
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
      local files = require('mini.files')
      local ignores = { '.DS_Store', '.git', 'node_modules' }

      local filter_hidden = function(entry)
        if vim.tbl_contains(ignores, entry.name) then
          return false
        end
        return true
      end

      local filter_noop = function(entry)
        return true
      end

      local toggle_hidden = function()
        files.config = vim.tbl_deep_extend('force', files.config, {
          content = {
            filter = files.config.content.filter == filter_noop and filter_hidden or filter_noop,
          },
        })
        files.refresh(files.config)
      end

      files.setup({
        content = {
          filter = filter_hidden,
        },

        mappings = {
          close = 'q',
          go_in = 'l',
          go_in_plus = 'e',
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

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          local file = function(fn)
            local entry = files.get_fs_entry()
            if entry.fs_type == 'file' then
              files.close()
              fn(entry.path)
            end
          end

          vim.keymap.set('n', '<CR>', function()
            file(require('telescope-config.open').open)
          end, { buffer = buf_id })

          vim.keymap.set('n', 't', function()
            file(vim.cmd.tabe)
          end, { buffer = buf_id, desc = 'Open in tab' })

          vim.keymap.set('n', 'v', function()
            file(vim.cmd.vsplit)
          end, { buffer = buf_id, desc = 'Open in vertical split' })

          vim.keymap.set('n', 'x', function()
            file(vim.cmd.split)
          end, { buffer = buf_id, desc = 'Open in hotizontal split' })

          vim.keymap.set('n', '.', function()
            toggle_hidden()
          end, { buffer = buf_id, desc = 'Toggle hidden' })
        end,
      })
    end,
  },
}
