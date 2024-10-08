return {
  {
    'echasnovski/mini.nvim',

    dependencies = {
      'josa42/nvim-telescope-config',
    },

    lazy = false,

    keys = function()
      local map = require('config.utils.map')
      -- local utils = require('telescope-config').utils

      -- File Browser
      -- e  -> file browser
      -- we -> file browser in workspace
      -- re -> file browser in repo root
      -- ce -> file browser in config
      -- ca -> file browser in github action workflows
      return map.keys('e', 'Explore', function(dir)
        require('mini.files').open(dir)
      end)
    end,

    config = function()
      --------------------------------------------------------------------------
      -- Notify

      local notify = require('mini.notify')

      notify.setup({})
      vim.notify = notify.make_notify()

      --------------------------------------------------------------------------
      -- Files

      local files = require('mini.files')
      local ignores = { '.DS_Store', '.git', 'node_modules' }

      local filter_hidden = function(entry)
        if vim.tbl_contains(ignores, entry.name) then
          return false
        end
        return true
      end

      local filter_noop = function(--[[ entry ]])
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
