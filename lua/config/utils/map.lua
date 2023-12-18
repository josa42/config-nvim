local paths = require('config.paths')
local M = {}

local function git_root()
  local git_path = vim.fs.find('.git', { upward = true, limit = 1 })[1]
  if git_path ~= nil then
    return vim.fs.dirname(git_path)
  end
end

function M.in_root(fn)
  return function()
    local git_path = vim.fs.find('.git', { upward = true, limit = 1 })[1]

    if git_path ~= nil then
      fn(vim.fs.dirname(git_path))
    else
      print('Could not find root')
    end
  end
end

function M.in_config(fn)
  return function()
    return fn(paths.config_dir)
  end
end

function M.in_workspace(fn)
  return function()
    return fn(require('jg.telescope-workspaces').get_current_workspace_path())
  end
end

function M.in_github_workflows(fn)
  return M.in_root(function(root)
    fn(vim.fs.joinpath(root, '.github/workflows'))
  end)
end

function M.key(key, desc, fn)
  return { '<leader>' .. key, fn, desc = desc }
end

function M.key_workspace(key, desc, fn)
  return { '<leader>w' .. key, M.in_workspace(fn), desc = ('%s in workspace'):format(desc) }
end

function M.key_root(key, desc, fn)
  return { '<leader>r' .. key, M.in_root(fn), desc = ('%s in root'):format(desc) }
end

function M.key_github_workflows(key, desc, fn)
  return { '<leader>a' .. key, M.in_github_workflows(fn), desc = ('%s in github workflows'):format(desc) }
end

function M.key_config(key, desc, fn)
  return { '<leader>c' .. key, M.in_config(fn), desc = ('%s in config'):format(desc) }
end

function M.keys(key, desc, fn)
  return {
    M.key(key, desc, fn),
    M.key_workspace(key, desc, fn),
    M.key_root(key, desc, fn),
    M.key_github_workflows(key, desc, fn),
    M.key_config(key, desc, fn),
  }
end

function M.append_keys(keys, key, desc, fn)
  for _, key in pairs(M.keys(key, desc, fn)) do
    table.insert(keys, key)
  end
end

function M.append_key(keys, key, desc, fn)
  table.insert(keys, M.key(key, desc, fn))
end

return M
