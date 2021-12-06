local layer = require('jg.lib.layer')

layer.use({
  enabled = true,

  require = {
    'stevearc/dressing.nvim',
    'MunifTanjim/nui.nvim',
  },

  after = function()
    require('dressing').setup({
      input = {
        anchor = 'NW',
        row = 1,
      },
      select = {
        backend = { 'nui' },
        get_config = function(opts)
          if opts.kind == 'codeaction' or opts.kind == 'file' then
            return {
              backend = 'nui',
              nui = {
                relative = 'cursor',
                position = 1,
              },
            }
          end
        end,
      },
    })
  end,
})

layer.use({
  enabled = false,

  require = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },

  after = function()
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values

    vim.ui.select = function(items, opts, on_choice)
      local format_item = opts.format_item or tostring
      pickers.new({}, {
        prompt_title = opts.prompt or 'Select one of:',
        finder = finders.new_table({
          results = items,
          entry_maker = function(item)
            local text = format_item(item)
            return { text = text, display = text, ordinal = text, value = item }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry(prompt_bufnr)
            actions.close(prompt_bufnr)

            on_choice(selection and selection.value)
          end)
          return true
        end,
      }):find()
    end
  end,
})
