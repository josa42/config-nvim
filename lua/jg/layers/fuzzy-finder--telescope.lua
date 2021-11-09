if __flags.fuzzy_finder ~= 'telescope' then
  return
end

local fs = require('jg.lib.fs')
local layer = require('jg.lib.layer')

local ts = {}

layer.use({
  require = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
    'itchyny/vim-gitbranch',
  },

  map = function()
    return {
      { 'n', __keymaps.find_file, ts.find_files },
      { 'n', __keymaps.find_string, ts.find_string },
      { 'n', __keymaps.find_config, ts.find_config },
      { 'n', '<leader>d', ts.find_docs },
      { 'n', __keymaps.find_help, ts.find_help },
      { 'n', '<leader>g', ts.git_status_files },
      { 'n', '<leader>p', ts.find_in_workspace },
    }
  end,

  after = function()
    local actions = require('telescope.actions')
    local action_set = require('telescope.actions.set')
    local action_state = require('telescope.actions.state')

    local edit = require('jg.lib.open').edit
    local switch_to = require('jg.lib.open').switch_to
    local buf_is_empty = require('jg.lib.open').buf_is_empty

    local function select_edit(prompt_bufnr, type)
      action_set.edit(prompt_bufnr, action_state.select_key_to_edit_key(type))
    end

    local select_edit_action = function(prompt_bufnr)
      select_edit(prompt_bufnr, 'default')
    end

    local function select(bufnr, type)
      if type == 'default' then
        local entry = action_state.get_selected_entry()
        if entry.filename then
          local filename = entry.path or entry.filename

          actions.close(bufnr)

          if not switch_to(filename) then
            if buf_is_empty() then
              edit('edit', filename)
            else
              edit('tabedit', filename)
            end
          end
        end
      else
        select_edit(bufnr, type)
      end
    end

    local create_action = function(prompt_bufnr)
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local file = action_state.get_current_line()
      if file == '' then
        return
      end

      if current_picker.cwd then
        file = current_picker.cwd .. '/' .. file
      end

      actions.close(prompt_bufnr)
      edit('tabe', file)
    end

    require('telescope').setup({
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = { mirror = false, width = 0.8, preview_width = 0.5 },
          vertical = { mirror = true },
          prompt_position = 'top',
        },
        sorting_strategy = 'ascending',
        prompt_prefix = '→ ',
        selection_caret = '→ ',
        entry_prefix = '  ',
        default_mappings = {
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,

            ['<esc>'] = actions.close,

            ['<Down>'] = actions.move_selection_next,
            ['<Up>'] = actions.move_selection_previous,

            ['<CR>'] = actions.select_default + actions.center,
            ['<C-e>'] = select_edit_action,
            ['<C-x>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['<C-t>'] = actions.select_tab,
            ['<C-n>'] = create_action,

            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-d>'] = actions.preview_scrolling_down,

            ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
            ['<C-l>'] = actions.complete_tag,

            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<C-a>'] = actions.add_selected_to_qflist + actions.open_qflist,
          },
        },
        preview_title = false,
        prompt_title = false,
        results_title = false,
        borderchars = {
          { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          prompt = { '─', '│', '─', '│', '┌', '┐', '┤', '├' },
          results = { ' ', '│', '─', '│', '│', '│', '┘', '└' },
          preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
        file_ignore_patterns = { '.git/', '.DS_Store', 'node_modules/' },
      },
    })
    require('telescope').load_extension('fzy_native')

    vim.cmd([[ highlight TelescopeNormal guibg=#2c323c ]])
    vim.cmd([[ highlight TelescopeBorder guibg=#2c323c guifg=#5c6370 ]])
    vim.cmd([[ highlight TelescopePreviewBorder guibg=#282c34 guifg=#5c6370 ]])
    vim.cmd([[ highlight TelescopeSelection guifg=#ffffff ]])
    vim.cmd([[ highlight TelescopeMultiSelection guifg=#61afef gui=bold ]])
    vim.cmd([[ highlight TelescopeSelectionCaret guifg=#61afef ]])

    local function get_find_command(...)
      if fs.binExist('fd') then
        local cmd = { 'fd', '--hidden', '--type=f', ... }

        local excludes = { '*.png', '*.jpg', '*.jpeg', '*.pdf' }
        for _, ex in ipairs(excludes) do
          table.insert(cmd, '--exclude=' .. ex)
        end

        return cmd
      end
    end

    local function default_opts(opts)
      return vim.tbl_extend('keep', opts or {}, {
        prompt_title = false,
        preview_title = false,
        results_title = false,
        attach_mappings = function(prompt_bufnr, map)
          action_set.select:replace(select)
          return true
        end,
        find_command = get_find_command(),
      })
    end

    function ts.find_files()
      require('telescope.builtin').find_files(default_opts({ hidden = true }))
    end

    function ts.find_files_in(path)
      require('telescope.builtin').find_files(default_opts({
        cwd = path,
        prompt_prefix = '[' .. path .. '] → ',
      }))
    end

    function ts.find_string()
      require('telescope.builtin').live_grep(default_opts({ preview_title = false }))
    end

    function ts.find_config()
      require('telescope.builtin').find_files(default_opts({ cwd = '~/.config/nvim' }))
    end

    function ts.find_docs()
      require('telescope.builtin').find_files(default_opts({ find_command = get_find_command('--glob', '*.md', '.') }))
    end

    function ts.find_help()
      require('telescope.builtin').help_tags(default_opts())
    end

    function ts.git_status_files()
      require('telescope.builtin').git_status(default_opts())
    end

    function ts.find_in_workspace()
      ts.find_files_in(require('jg.lib.workspaces').current_workspace_path())
    end

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
