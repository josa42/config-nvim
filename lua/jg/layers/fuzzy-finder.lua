local layer = require('jg.lib.layer')
local paths = require('jg.lib.paths')

local ts = {}

layer.use({
  requires = {
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        { 'josa42/nvim-telescope-minimal-layout' },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-lua/plenary.nvim',
      },
    },
    'itchyny/vim-gitbranch',
    'josa42/nvim-telescope-workspaces',
  },

  map = function()
    local builtin = require('telescope.builtin')

    return {
      { 'n', __keymaps.find_file, ts.find_files, label = 'Find files' },
      { 'n', __keymaps.find_string, ts.find_string, label = 'Find string' },
      { 'n', __keymaps.find_config, ts.find_config, label = 'Find config' },
      { 'n', '<leader>d', ts.find_docs, label = 'Find docs' },
      { 'n', __keymaps.find_help, builtin.help_tags, label = 'Find help' },
      { 'n', '<leader>gs', builtin.git_status, label = 'Git status' },
      { 'n', '<leader>gb', builtin.git_bcommits, label = 'Git buffer commits' },
      { 'n', '<leader>gl', builtin.git_commits, label = 'Git commits' },
      { 'n', '<leader><leader>', ts.find_file_in_workspace },
      { 'n', '<leader>p', ts.find_file_in_workspace },
      { 'n', '<leader>f', ts.find_string_in_workspace },
      { 'n', '<leader>w', ts.select_workspace },
      { 'n', '<leader>j', builtin.jumplist },
      { 'n', '<leader>/', ts.find_string_in_buffer },
      { 'n', '<leader>rf', builtin.oldfiles },
      { 'n', '<leader>m', require('jg.lib.telescope-marks').marks },
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

    local function make_gen_from_file(opts)
      local gen = make_entry.gen_from_file(opts)
      return function(filename)
        return gen(filename:gsub('^%./', ''))
      end
    end

    local function entry_path(entry)
      return entry.path or entry.filename
    end

    local function action_edit(prompt_bufnr, type)
      action_set.edit(prompt_bufnr, action_state.select_key_to_edit_key('default'))
    end

    local function action_select(bufnr)
      local entry = action_state.get_selected_entry()
      local filepath = entry_path(entry)
      if filepath then
        actions.close(bufnr)
        open(filepath, entry.lnum and { entry.lnum, entry.col or 0 } or nil)
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
        attach_mappings = function()
          action_set.select:replace_if(function(_, type)
            local entry = action_state.get_selected_entry()
            return type == 'default' and entry_path(entry) and not entry.cmd
          end, action_select)

          return true
        end,
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
          entry_maker = make_gen_from_file({ cwd = path }),
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
          entry_maker = make_gen_from_file(),
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
        highlights = {
          preview = { hide_on_startup = false },
        },
      }),
      defaults = {
        layout_strategy = 'minimal',
        layout_config = {
          prompt_position = 'top',
        },
        sorting_strategy = 'ascending',
        prompt_prefix = get_prompt_prefix(),
        selection_caret = '→ ',
        entry_prefix = '  ',
        preview = {
          hide_on_startup = true,
        },
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
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
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
    telescope.load_extension('minimal_layout')

    function ts.find_files(path)
      builtin.find_files(set_path(path))
    end

    function ts.find_string(path)
      builtin.live_grep(set_path(path))
    end

    function ts.find_config()
      builtin.find_files(set_path(paths.config_dir))
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

      vim.ui.select(ws.get_workspaces(), { prompt = 'Workspace' }, function(w)
        ws.set_current_workspace(w)
      end)
    end

    function ts.find_string_in_buffer()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({ previewer = false }))
    end

    vim.api.nvim_create_user_command('Find', function(opts)
      ts.find_files(opts.args)
    end, {
      nargs = 1,
      complete = 'file',
    })
  end,
})
