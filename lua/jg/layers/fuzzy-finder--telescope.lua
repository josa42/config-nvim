local layer = require('jg.lib.layer')
local paths = require('jg.lib.paths')

local ts = {}

layer.use({
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' } },
    'itchyny/vim-gitbranch',
    'josa42/nvim-telescope-select',
    'josa42/nvim-telescope-workspaces',
  },

  map = function()
    local builtin = require('telescope.builtin')

    return {
      { 'n', __keymaps.find_file, ts.find_files, nil, 'Find files' },
      { 'n', __keymaps.find_string, ts.find_string, nil, 'Find string' },
      { 'n', __keymaps.find_config, ts.find_config, nil, 'Find config' },
      { 'n', '<leader>d', ts.find_docs, nil, 'Find docs' },
      { 'n', __keymaps.find_help, builtin.help_tags, nil, 'Find help' },
      { 'n', '<leader>gs', builtin.git_status, nil, 'Git status' },
      { 'n', '<leader>gb', builtin.git_bcommits, nil, 'Git buffer commits' },
      { 'n', '<leader>gg', builtin.git_commits, nil, 'Git commits' },
      { 'n', '<leader><leader>', ts.find_file_in_workspace },
      { 'n', '<leader>p', ts.find_file_in_workspace },
      { 'n', '<leader>f', ts.find_string_in_workspace },
      { 'n', '<leader>w', ts.select_workspace },
    }
  end,

  setup = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local actions = require('telescope.actions')
    local action_layout = require('telescope.actions.layout')
    local action_set = require('telescope.actions.set')
    local action_state = require('telescope.actions.state')
    local make_entry = require('telescope.make_entry')

    local open = require('jg.lib.open').open
    local edit = require('jg.lib.open').edit

    local function action_edit(prompt_bufnr)
      action_set.edit(prompt_bufnr, action_state.select_key_to_edit_key('default'))
    end

    local function action_select(bufnr, type)
      if type == 'default' then
        local entry = action_state.get_selected_entry()
        local filepath = entry.path or entry.filename
        if filepath then
          actions.close(bufnr)
          open(filepath, entry.lnum and { entry.lnum, entry.col or 0 } or nil)
        end
      else
        action_set.edit(bufnr, action_state.select_key_to_edit_key(type))
      end
    end

    local function create_action(prompt_bufnr)
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

    local function get_prompt_prefix(path)
      if path ~= nil and path ~= '.' then
        return '[' .. path .. '] → '
      end
      return '→ '
    end

    local function default_opts(opts)
      opts = opts or {}

      return vim.tbl_extend('keep', opts, {
        prompt_title = false,
        preview_title = false,
        results_title = false,
        attach_mappings = function(prompt_bufnr, map)
          action_set.select:replace(action_select)
          return true
        end,
        preview = vim.tbl_extend('keep', opts.preview or {}, {
          hide_on_startup = true,
        }),
      })
    end

    local function set_path(path, opts)
      if path ~= nil and path ~= '.' then
        if string.sub(path, 1, paths.home:len()) == paths.home then
          path = '~' .. string.sub(path, paths.home:len() + 1)
        end

        return vim.tbl_extend('keep', {
          cwd = path,
          prompt_prefix = get_prompt_prefix(path),
        }, opts or {})
      end

      return opts
    end

    local function picker_default_opts(pickers)
      for key in pairs(builtin) do
        pickers[key] = default_opts(pickers[key])
      end
      return pickers
    end

    telescope.setup({
      pickers = picker_default_opts({
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { '--hidden' }
          end,
          preview = { hide_on_startup = false },
        },
        help_tags = {
          preview = { hide_on_startup = false },
        },
        git_bcommits = {
          preview = { hide_on_startup = false },
        },
        git_commits = {
          preview = { hide_on_startup = false },
        },
      }),
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = { mirror = false, width = 0.75, preview_width = 0.5 },
          vertical = { mirror = true },
          prompt_position = 'top',
        },
        sorting_strategy = 'ascending',
        prompt_prefix = get_prompt_prefix(),
        selection_caret = '→ ',
        entry_prefix = '  ',
        mappings = {
          i = {
            ['<C-Down>'] = actions.cycle_history_next,
            ['<C-Up>'] = actions.cycle_history_prev,

            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,

            ['<esc>'] = actions.close,

            ['<Down>'] = actions.move_selection_next,
            ['<Up>'] = actions.move_selection_previous,

            ['<CR>'] = actions.select_default + actions.center,
            ['<C-e>'] = action_edit,
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

            ['<c-p>'] = action_layout.toggle_preview,
          },
        },
        borderchars = {
          { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          prompt = { '─', '│', '─', '│', '╭', '╮', '┤', '├' },
          results = { ' ', '│', '─', '│', '│', '│', '╯', '╰' },
          preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        },
        file_ignore_patterns = {
          '%.git$',
          '%.git/',
          '%.DS_Store$',
          'node_modules/',
          '%.(png|PNG|jpe?g|JPE?G|pdf|PDF)$',
        },
      },
    })

    telescope.load_extension('fzf')

    function ts.find_files(path)
      builtin.find_files(set_path(path))
    end

    function ts.find_string(path)
      builtin.live_grep(set_path(path))
    end

    function ts.find_config()
      builtin.find_files(set_path(paths.configDir))
    end

    function ts.find_docs()
      builtin.find_files({
        find_command = { 'fd', '--type=f', '--glob', '*.md' },
      })
    end

    -- TODO extract into josa42/nvim-telescope-workspaces
    function ts.find_file_in_workspace()
      ts.find_files(require('jg.telescope-workspaces').get_current_workspace_path())
    end

    -- TODO extract into josa42/nvim-telescope-workspaces
    function ts.find_string_in_workspace()
      ts.find_string(require('jg.telescope-workspaces').get_current_workspace_path())
    end

    -- TODO extract into josa42/nvim-telescope-workspaces
    function ts.select_workspace()
      local ws = require('jg.telescope-workspaces')

      ts.select(ws.get_workspaces(), { prompt = 'Workspace' }, function(w)
        ws.set_current_workspace(w)
      end)
    end

    ts.select = require('jg.telescope-select').select

    vim.ui.select = ts.select

    vim.api.nvim_add_user_command('Find', function(opts)
      ts.find_files(opts.args)
    end, {
      nargs = 1,
      complete = 'file',
    })
  end,
})
