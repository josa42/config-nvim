local fs = require('jg.lib.fs')

local M = {}

local function basename(path)
	return path:gsub("(.*/)(.*)", "%2")
end

function M.get_workspaces()
  local pkg = fs.read_json('package.json');

  local ns = {}

  for _,pattern in ipairs(pkg.workspaces) do
    for _,path in ipairs(vim.fn.glob(pattern, false, true)) do
      ns[basename(path)] = path
    end
  end

  return ns
end

function M.current_workspace()
  local branch = vim.fn['gitbranch#name']()
  local name = branch:gsub(".*/(.*)/.*", "%1")
  return name

end

function M.current_workspace_path()
  local ns = M.get_workspaces()
  return ns[M.current_workspace()]
end

return M
