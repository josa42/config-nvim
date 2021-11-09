local M = {}

-- vim.fn.json_decode(vim.fn.join(vim.fn.readfile('./package.json')), '\n'))

local function read_file(path)
  return vim.fn.join(vim.fn.readfile('./package.json'), '\n')
end

local function read_json_file(path)
  return vim.fn.json_decode(read_file(path))
end

local function get_workspaces()
  local pkg = read_json_file('./package.json')

  local workspaces = {}

  for _, value in ipairs(pkg.workspaces) do
    if vim.regex('*$'):match_str(value) then
      local p, _ = string.gsub(value, '*', '')
      for _, fvalue in ipairs(vim.fn.readdir(p)) do
        if not vim.regex('^\\.'):match_str(fvalue) then
          table.insert(workspaces, p .. fvalue)
        end
      end
    else
      table.insert(workspaces, value)
    end
  end

  return workspaces
end

local function select_workspace(cb)
  M.select(get_workspaces(), function(dir)
    cb(dir)
  end)
end

local function buf_workspace()
  local dir = vim.fn.expand('%:h')
  if dir then
    for _, workspace in ipairs(get_workspaces()) do
      if string.sub(dir, 0, string.len(workspace)) == workspace then
        return workspace
      end
    end
  end

  return '.'
end

function M.select_workspace()
  select_workspace(function(dir)
    _G.__current_workspace = dir
    print('Workspace: ' .. dir)
  end)
end

function M.selected_workspace_files()
  M.files(_G.__current_workspace)
end

function M.current_workspace_files()
  local workspace = buf_workspace()
  M.files(workspace)
end

function M.workspace_files()
  select_workspace(M.files)
end

function M.select(options, select_cb, opts)
  opts = opts or {}

  if _G.__flags.fuzzy_finder == 'fzf' then
    return vim.fn['fzf#select#open'](options, select_cb)
  end

  if _G.__flags.fuzzy_finder == 'telescope' then
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local sorters = require('telescope.sorters')
    local actions = require('telescope.actions')
    local actions_state = require('telescope.actions.state')

    local picker = pickers.new({
      prompt_title = opts.title,
      finder = finders.new_table(options),
      sorter = sorters.fuzzy_with_index_bias(),
      attach_mappings = function()
        actions.select_default:replace(function(bufnr)
          select_cb(actions_state.get_selected_entry()[1])
          actions.close(bufnr)
        end)
        return true
      end,
    })

    return picker:find()
  end
end

function M.files(dir)
  if _G.__flags.fuzzy_finder == 'fzf' then
    return vim.fn['fzf#vim#files'](dir)
  end

  if _G.__flags.fuzzy_finder == 'telescope' then
    local title = nil
    if dir == '.' then
      dir = nil
    end

    if dir then
      title = dir
    end
    return require('telescope.builtin').find_files({ cwd = dir, prompt_title = title })
  end
end

return M
